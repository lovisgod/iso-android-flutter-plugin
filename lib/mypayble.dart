
import 'mypayble_platform_interface.dart';

class Mypayble {
  Future<String?> getPlatformVersion() {
    return MypayblePlatform.instance.getPlatformVersion();
  }

  Future<String?> initializeSdk() {
    return MypayblePlatform.instance.initiateSdk();
  }

}
