import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:helper_app/in_app_purchase/subscription_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

void showGoPremiumDialog(BuildContext context, {required Function(ProductDetails?) productDetailsResult}) {
  showModalBottomSheet<bool?>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    showDragHandle: true,
    context: context,
    builder: (BuildContext context) {
      return Consumer<InAppPurchaseService>(
        builder: (context, inAppPurchaseService, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 5),
                  _buildFeatures(context),
                  const SizedBox(height: 10),
                  _buildSubscriptionOptions(context, inAppPurchaseService),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      // launchSite(privacyPolicy);
                    },
                    child: Text(
                      "End User Agreement",
                      style: TextStyle(color: Theme.of(context).primaryColorLight),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildSubscribeButton(context, inAppPurchaseService),
                  _buildRestorePurchaseButton(context, inAppPurchaseService),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((value) async {
    if (value != true || !context.mounted) return;
    if (context.read<InAppPurchaseService>().selectedProDetails == null && context.mounted) {
      log("Select Premium Plan");
      return;
    }

    productDetailsResult(context.read<InAppPurchaseService>().selectedProDetails);
  });
}

Widget _buildHeader(BuildContext context) {
  return Column(
    children: [
      // Image.asset(
      //   "assets/logo_colored.png",
      //   width: 30,
      // ),
      // const SizedBox(height: 10),
      Text(
        "unlock premium benefits",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    ],
  );
}

Widget _buildFeatures(BuildContext context) {
  return Column(
    children: [
      for (var feature in _premiumFeatures)
        Text(
          feature,
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
    ],
  );
}

Widget _buildSubscriptionOptions(BuildContext context, InAppPurchaseService inAppPurchaseService) {
  final theme = Theme.of(context);

  return Column(
    children: [
      // for (var plan in inAppPurchaseService.availableProducts)
      ...List.generate(inAppPurchaseService.availableProducts.length, (index) {
        final plan = inAppPurchaseService.availableProducts[index];
        return GestureDetector(
          onTap: () {
            inAppPurchaseService.selectedProDetails = plan;
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: _buildPlanDetails(plan, inAppPurchaseService),
          ),
        );
      })
    ],
  );
}

Widget _buildSubscribeButton(BuildContext context, InAppPurchaseService inAppPurchaseService) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            child: Text(
              "Subscribe Now",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildRestorePurchaseButton(BuildContext context, InAppPurchaseService inAppPurchaseService) {
  return TextButton(
    onPressed: () {
      inAppPurchaseService.restorePurchases();
      Navigator.of(context).pop();
    },
    child: Text(
      "Restore Purchase",
      style: TextStyle(color: Theme.of(context).primaryColorLight),
    ),
  );
}

Widget _buildPlanDetails(ProductDetails productDetails, InAppPurchaseService inAppPurchaseService) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: inAppPurchaseService.selectedProDetails?.id == productDetails.id
          ? Border.all(color: Colors.blue, width: 2)
          : null,
    ),
    child: ListTile(
      dense: true,
      title: Text(
        productDetails.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        productDetails.description,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            productDetails.price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _getDurationTitleByProductID(productDetails.id),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ),
  );
}

final _premiumFeatures = [
  "Access premium templates",
  "Unlock unique fonts and backgrounds",
  "Remove watermarks for a cleaner appearance",
  "Export in 4K and other resolutions",
  "Sync screenshots across devices",
  "Enjoy new Pro features at no extra cost"
];

String _getDurationTitleByProductID(String idCode) {
  if (idCode == "auto_renew_monthly_plan") {
    return "per month";
  }
  return "per year";
}
