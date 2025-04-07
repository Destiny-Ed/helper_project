import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:helper_app/animations/home.dart';
import 'package:helper_app/in_app_purchase/dialog.dart';
import 'package:helper_app/in_app_purchase/subscription_helper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => InAppPurchaseService())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AnimationHome(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<InAppPurchaseService>().initialize();
  }

  @override
  void dispose() {
    context.read<InAppPurchaseService>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColorLight,
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).primaryColorLight),
                  ),
                ),
              ),
              onPressed: () {
                showGoPremiumDialog(
                  context,
                  productDetailsResult: (details) async {
                    final inAppPurchaseService = context.read<InAppPurchaseService>();

                    final purchaseResult = await inAppPurchaseService.purchaseProduct(details!);

                    if (purchaseResult.$1 && context.mounted) {
                      log("Premium purchase was successful!");
                    } else {
                      if (context.mounted) {
                        log(purchaseResult.$2);
                      }
                    }
                  },
                );
              },
              child: Text(
                "Upgrade Plan - Subscription",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
