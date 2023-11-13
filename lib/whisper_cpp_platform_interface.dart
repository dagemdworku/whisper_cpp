import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:whisper_cpp/whisper_cpp.dart';

import 'whisper_cpp_method_channel.dart';

abstract class WhisperCppPlatform extends PlatformInterface {
  /// Constructs a WhisperCppPlatform.
  WhisperCppPlatform() : super(token: _token);

  static final Object _token = Object();

  static WhisperCppPlatform _instance = MethodChannelWhisperCpp();

  /// The default instance of [WhisperCppPlatform] to use.
  ///
  /// Defaults to [MethodChannelWhisperCpp].
  static WhisperCppPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WhisperCppPlatform] when
  /// they register themselves.
  static set instance(WhisperCppPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<bool> get isRecording =>
      throw UnimplementedError('get isRecording stream is not implemented');

  Stream<String> get statusLog =>
      throw UnimplementedError('get statusLog stream is not implemented');

  Stream<WhisperResult?> get result =>
      throw UnimplementedError('get result stream is not implemented');

  Stream<List<WhisperResult>> get results =>
      throw UnimplementedError('get results stream is not implemented');
      
  Stream<WhisperSummary?> get summary =>
      throw UnimplementedError('get summary stream is not implemented');

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<WhisperConfig> initialize({
    required String modelName,
    required bool isDebug,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> toggleRecord() {
    throw UnimplementedError('toggleRecord() has not been implemented.');
  }
}
