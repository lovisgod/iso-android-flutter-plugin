import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mypayble_platform_interface.dart';

/// An implementation of [MypayblePlatform] that uses method channels.
class MethodChannelMypayble extends MypayblePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mypayble');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> initiateSdk() async {
    final result = await methodChannel.invokeMethod<String>('initiateSdk');
    return result;
  }

  @override
  Future<dynamic?> initiateKeyAndDetailsDownload(String terminalId) async {
    final result = await methodChannel.invokeMethod("initiateKeyAndDetailsDownload", {
      'terminalId': terminalId
    });
    return result;
  }
  
  @override
  Future<dynamic?> initiatePurchase(Map<String, dynamic> terminalInfo,
      Map<String, dynamic> transactionInfo, String AccountType, String iccData) async {
    final result = await methodChannel.invokeMethod("initiatePurchase", {
      'terminalInfoMap': terminalInfo,
      'transactionInfo': transactionInfo,
      'accountType': AccountType,
      'iccData': iccData
    });
    return result;
  }

}
