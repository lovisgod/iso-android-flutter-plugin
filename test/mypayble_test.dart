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
    // TODO: implement initiateSdk
    return Future.value('success');
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
