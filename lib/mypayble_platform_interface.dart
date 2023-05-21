import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mypayble_method_channel.dart';

abstract class MypayblePlatform extends PlatformInterface {
  /// Constructs a MypayblePlatform.
  MypayblePlatform() : super(token: _token);

  static final Object _token = Object();

  static MypayblePlatform _instance = MethodChannelMypayble();

  /// The default instance of [MypayblePlatform] to use.
  ///
  /// Defaults to [MethodChannelMypayble].
  static MypayblePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MypayblePlatform] when
  /// they register themselves.
  static set instance(MypayblePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> initiateSdk() {
    throw UnimplementedError('this has not been implemented');
  }

  Future<dynamic?> initiateKeyAndDetailsDownload(String terminalId) {
    throw UnimplementedError("initiateKey download has not been implemented");
  }

  Future<dynamic?> initiatePurchase(Map<String, dynamic> terminalInfo,
      Map<String, dynamic> transactionInfo, String AccountType, String iccData) {
    throw UnimplementedError("initiate purchase has not been implemented");
  }
}
