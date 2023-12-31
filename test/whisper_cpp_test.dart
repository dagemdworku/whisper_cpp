import 'package:flutter_test/flutter_test.dart';
import 'package:whisper_cpp/whisper_cpp.dart';
import 'package:whisper_cpp/whisper_cpp_platform_interface.dart';
import 'package:whisper_cpp/whisper_cpp_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWhisperCppPlatform
    with MockPlatformInterfaceMixin
    implements WhisperCppPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  // TODO: implement isRecording
  Future<WhisperConfig> initialize(
          {required String modelName, required bool isDebug}) =>
      throw UnimplementedError();

  @override
  // TODO: implement isRecording
  Future<bool> toggleRecord() => throw UnimplementedError();

  @override
  // TODO: implement isRecording
  Stream<bool> get isRecording => throw UnimplementedError();

  @override
  // TODO: implement statusLog
  Stream<String> get statusLog => throw UnimplementedError();

  @override
  // TODO: implement result
  Stream<WhisperResult?> get result => throw UnimplementedError();

  @override
  // TODO: implement summary
  Stream<WhisperSummary?> get summary => throw UnimplementedError();

  @override
  // TODO: implement results
  Stream<List<WhisperResult>> get results => throw UnimplementedError();

  @override
  // TODO: implement isModelLoaded
  Stream<bool> get isModelLoaded => throw UnimplementedError();

  @override
  // TODO: implement canTranscribe
  Stream<bool> get canTranscribe => throw UnimplementedError();

  @override
  Future<void> transcribe() {
    // TODO: implement transcribe
    throw UnimplementedError();
  }

  @override
  // TODO: implement samples
  Stream<List<double>> get samples => throw UnimplementedError();
}

void main() {
  final WhisperCppPlatform initialPlatform = WhisperCppPlatform.instance;

  test('$MethodChannelWhisperCpp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWhisperCpp>());
  });

  test('getPlatformVersion', () async {
    WhisperCpp whisperCppPlugin = WhisperCpp();
    MockWhisperCppPlatform fakePlatform = MockWhisperCppPlatform();
    WhisperCppPlatform.instance = fakePlatform;

    expect(await whisperCppPlugin.getPlatformVersion(), '42');
  });
}
