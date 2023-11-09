import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whisper_cpp/whisper_cpp_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelWhisperCpp platform = MethodChannelWhisperCpp();
  const MethodChannel channel = MethodChannel('whisper_cpp');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
