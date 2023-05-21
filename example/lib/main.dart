import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mypayble/mypayble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _mypayblePlugin = Mypayble();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _mypayblePlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  //Initiate the upstreamsdk initialization
  Future<void> initUpstreamSdk() async {
    String response;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      response =
          await _mypayblePlugin.initializeSdk() ?? 'Error Initializing Upstream SDK';
    } on PlatformException {
      response = 'Failed to initialize sdk.';
    }
  }

  //Initiate the upstream download key sdks
  Future<dynamic?> initDownloadKeys(String terminalId) async {
    dynamic response;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      response =
          await _mypayblePlugin.initiateKeyAndDetailsDownload(terminalId) ??
              'Error Initializing Upstream Download key';


      print(response);

    } on PlatformException {
      response = 'Failed to download jey sdk.';
    }
  }

  // Initiate the upstream purchase using sdk
  Future<dynamic?> initPurchase() async {
    final terminalInfoMap = <String, String>{};
    terminalInfoMap["merchantCategoryCode"] = "8099";
    terminalInfoMap["terminalCode"] = "2ISW0001";
    terminalInfoMap["merchantId"] = "2ISW1234567TEST";
    terminalInfoMap["merchantName"] = "ISW TEST POS           LA           LANG";



    final transactionInfoMap = <String, dynamic>{};
    transactionInfoMap["haspin"] =  false;
    transactionInfoMap["track2Data"] =  "5061071000066964892D2412601019747166F000000";
    transactionInfoMap["panSequenceNumber"] = "001";
    transactionInfoMap["amount"] = "1000";
    transactionInfoMap["pinBlock"] = "";
    transactionInfoMap["posDataCode"] = "510101511344101";

    const iccData = "";
    dynamic response;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      response =
          await _mypayblePlugin.initiatePurchase(terminalInfoMap, transactionInfoMap, "Default", iccData) ??
              'Error Initializing Upstream Purchase';


      print(response);

    } on PlatformException {
      response = 'Failed to download jey sdk.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  initUpstreamSdk();
                },
                child: Text('Click me'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  initDownloadKeys("2ISW0001");
                },
                child: Text('Donwload Keys and Details'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  initPurchase();
                },
                child: const Text('Perform Purchase'),
              )
            ],
          )
        ),
      ),
    );
  }
}
