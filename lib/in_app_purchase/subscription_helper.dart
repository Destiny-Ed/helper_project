import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helper_app/usecase/shared_pref_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  final SharedPreferenceUseCaseRepo _sharedPreferences = SharedPreferenceUseCaseRepo();

  ProductDetails? _selectedProDetails;
  ProductDetails? get selectedProDetails => _selectedProDetails;
  set selectedProDetails(ProductDetails? productDetails) {
    _selectedProDetails = productDetails;
    notifyListeners();
  }

  bool isLoading = false;

  /// Available products
  List<ProductDetails> availableProducts = [];

  Completer<bool>? _purchaseCompleter;

  InAppPurchaseService() {
    _listenToPurchaseUpdates();
  }

  /// Keys for local storage
  final String _lastPurchaseDateKey = "last_purchase_date";
  final String _purchaseDurationKey = "purchase_duration";

  ///Replace this with your subscription IDs
  Set<String> productIds = {
    'auto_renew_monthly_plan',
    'auto_renew_annual_plan',
  };

  /// Initialize and load available products
  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception("In-app purchases are not available on this device.");
    }

    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.notFoundIDs.isNotEmpty) {
      throw Exception("Some products were not found: ${response.notFoundIDs}");
    }

    availableProducts = response.productDetails;
    notifyListeners();

    if (availableProducts.isEmpty) {
      restorePurchases(); //similar to query past purchases
    }
  }

  /// Purchase a product
  Future<(bool, String)> purchaseProduct(ProductDetails product) async {
    isLoading = true;
    notifyListeners();
    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product, applicationUserName: "ap.screenshot.pro");

      if (productIds.contains(product.id)) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }

      _purchaseCompleter = Completer<bool>();

      // Wait for the purchase process to complete or timeout
      final purchaseResult = await _purchaseCompleter!.future.timeout(
        const Duration(seconds: 60), // Adjust timeout as needed
        onTimeout: () {
          _purchaseCompleter?.complete(false);
          return false; // Timeout handling
        },
      );

      if (purchaseResult) {
        return (true, "Purchase completed successfully!");
      } else {
        return (false, "Purchase failed or was cancelled.");
      }
    } on PlatformException catch (e) {
      if (e.code == 'storekit_duplicate_product_object') {
        // Notify the user about the pending transaction
        return (false, "There is a pending transaction. Please wait or restart the app.");
      } else {
        log("Purchase error: ${e.message}");
        // Handle other errors
        return (false, "Purchase error. Please try again or restart the app.");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases(applicationUserName: "ap.screenshot.pro");
  }

  /// Listen to purchase updates
  void _listenToPurchaseUpdates() {
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
          log("Received purchase update: $purchaseDetails");
          if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
            _processPurchase(purchaseDetails);
          } else if (purchaseDetails.status == PurchaseStatus.canceled) {
            _handlePurchaseCancellation(purchaseDetails);
          } else if (purchaseDetails.status == PurchaseStatus.error) {
            _handleError(purchaseDetails.error);
          }
        }
      },
      onError: (error) {
        debugPrint("Purchase stream error: $error");
      },
    );
  }

  /// Process and verify purchase
  Future<void> _processPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }

    try {
      final now = DateTime.now();
      final String userId = "user?.uid ?? " "";

      if (purchaseDetails.productID == 'auto_renew_monthly_plan') {
        await _savePurchase(purchaseDetails.productID, userId, now, 30);
      } else if (purchaseDetails.productID == 'auto_renew_annual_plan') {
        await _savePurchase(purchaseDetails.productID, userId, now, 365);
      }

      _purchaseCompleter?.complete(true);
    } catch (error) {
      debugPrint("Failed to process purchase: $error");
      _purchaseCompleter?.complete(false);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Save purchase to shared preferences and Firestore
  Future<void> _savePurchase(String productID, String uid, DateTime purchaseDate, int durationInDays) async {
    // final expiryDate = purchaseDate.add(Duration(days: durationInDays));
    // final newPlanType = productID == 'auto_renew_monthly_plan' ? PremiumPlans.monthly.name : PremiumPlans.annualy.name;

    // // Fetch the current planType from SharedPreferences
    // final currentPlanType = await _sharedPreferences.getString('planType');

    // // Only update if the plan type is different
    // if (currentPlanType != newPlanType) {
    //   // Save to SharedPreferences
    //   _sharedPreferences.setInt(_lastPurchaseDateKey, purchaseDate.millisecondsSinceEpoch);
    //   _sharedPreferences.setInt(_purchaseDurationKey, durationInDays);
    //   _sharedPreferences.setString('planType', newPlanType);

    //   // Prepare plan data for Firestore
    //   final planData = {
    //     'lastPurchaseDate': purchaseDate.millisecondsSinceEpoch,
    //     'purchaseDuration': durationInDays,
    //     'expiryDate': expiryDate.toIso8601String(),
    //     'productID': productID,
    //     'cancelled': false,
    //     'updatedAt': FieldValue.serverTimestamp(),
    //     'planType': newPlanType
    //   };

    //   // Save to Firestore
    //   await _firestore.collection('users').doc(uid).set(
    //     {
    //       'premiumPlan': planData,
    //     },
    //     SetOptions(merge: true),
    //   );
    // } else {
    //   debugPrint("Plan type is the same as the current plan. No updates required.");
    // }
  }

  /// Handle purchase cancellation
  Future<void> _handlePurchaseCancellation(PurchaseDetails purchaseDetails) async {
    try {
      final String userId = "user?.uid ?? " "";

      // await _firestore.collection('users').doc(userId).set(
      //   {
      //     'cancelled': true,
      //   },
      //   SetOptions(merge: true),
      // );

      debugPrint("Purchase cancellation handled successfully.");
    } catch (error) {
      debugPrint("Failed to handle purchase cancellation: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Handle purchase errors
  void _handleError(IAPError? error) {
    debugPrint("Purchase error: ${error?.details}");
    _purchaseCompleter?.complete(false);

    isLoading = false;
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    _purchaseSubscription?.cancel();
  }
}
