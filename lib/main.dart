import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paytabs Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Paytabs Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String serverKey = 'S2JN2GTZNL-JDB6ZG9JRM-LRLRJRGZHH';
  String clientKey = 'C2KMQP-6R2M6D-2G9TP6-NB6RDR';
  double amount = 100.0;

  @override
  void initState() {
    super.initState();
  }

  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails("HM Badhon", "hmbadhon@gmail.com",
        "+97311111111", "st. 12", "ae", "dubai", "dubai", "12345");
    var shippingDetails = ShippingDetails("HM Badhon", "hmbadhon@gmail.com",
        "+97311111111", "st. 12", "ae", "dubai", "dubai", "12345");
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.STC_PAY);
    var configuration = PaymentSdkConfigurationDetails(
      profileId: "*profile id*",
      serverKey: serverKey,
      clientKey: clientKey,
      cartId: "12433",
      cartDescription: "Flowers",
      merchantName: "Flowers Store",
      screentTitle: "Pay with Card",
      amount: amount,
      showBillingInfo: true,
      forceShippingInfo: false,
      currencyCode: "SAR",
      merchantCountryCode: "SA",
      billingDetails: billingDetails,
      shippingDetails: shippingDetails,
      alternativePaymentMethods: apms,
    );

    var theme = IOSThemeConfigurations();
    theme.logoImage = "assets/images/logo.png";
    configuration.iOSThemeConfigurations = theme;

    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(
      generateConfig(),
      (event) {
        setState(
          () {
            if (event["status"] == "success") {
              // Handle transaction details here.
              var transactionDetails = event["data"];
              log(transactionDetails);
            } else if (event["status"] == "error") {
              // Handle error here.
            } else if (event["status"] == "event") {
              // Handle events here.
            }
          },
        );
      },
    );
  }

  // Future<void> apmsPayPressed() async {
  //   FlutterPaytabsBridge.startAlternativePaymentMethod(await generateConfig(),
  //       (event) {
  //     setState(() {
  //       if (event["status"] == "success") {
  //         var transactionDetails = event["data"];
  //         print(transactionDetails);
  //       } else if (event["status"] == "error") {
  //       } else if (event["status"] == "event") {}
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PayTabs Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  payPressed();
                },
                child: const Text('Pay with Paytabs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
