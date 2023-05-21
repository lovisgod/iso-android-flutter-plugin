
import 'mypayble_platform_interface.dart';

class Mypayble {
  Future<String?> getPlatformVersion() {
    return MypayblePlatform.instance.getPlatformVersion();
  }

  Future<String?> initializeSdk() {
    return MypayblePlatform.instance.initiateSdk();
  }

  Future<dynamic?> initiateKeyAndDetailsDownload(String terminalId) {
    return MypayblePlatform.instance.initiateKeyAndDetailsDownload(terminalId);
  }


  Future<dynamic?> initiatePurchase(Map<String, dynamic> terminalInfo,
      Map<String, dynamic> transactionInfo, String AccountType, String iccData) {
    return MypayblePlatform.instance.initiatePurchase(terminalInfo, transactionInfo, AccountType, iccData);
  }

}
