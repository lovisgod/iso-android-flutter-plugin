import 'package:flutter_test/flutter_test.dart';
import 'package:mypayble/mypayble.dart';
import 'package:mypayble/mypayble_platform_interface.dart';
import 'package:mypayble/mypayble_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMypayblePlatform
    with MockPlatformInterfaceMixin
    implements MypayblePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> initiateSdk() {
    return Future.value('success');
  }

  @override
  Future<String?> initiateKeyAndDetailsDownload(String terminalId) {
    throw UnimplementedError();
  }

  @override
  Future initiatePurchase(Map<String, dynamic> terminalInfo,
      Map<String, dynamic> transactionInfo, String AccountType, String iccData) {
    throw UnimplementedError();
  }
}

void main() {
  final MypayblePlatform initialPlatform = MypayblePlatform.instance;

  test('$MethodChannelMypayble is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMypayble>());
  });

  test('getPlatformVersion', () async {
    Mypayble mypayblePlugin = Mypayble();
    MockMypayblePlatform fakePlatform = MockMypayblePlatform();
    MypayblePlatform.instance = fakePlatform;

    expect(await mypayblePlugin.getPlatformVersion(), '42');
  });
}
