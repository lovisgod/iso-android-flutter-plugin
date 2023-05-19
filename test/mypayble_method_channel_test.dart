import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mypayble/mypayble_method_channel.dart';

void main() {
  MethodChannelMypayble platform = MethodChannelMypayble();
  const MethodChannel channel = MethodChannel('mypayble');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
