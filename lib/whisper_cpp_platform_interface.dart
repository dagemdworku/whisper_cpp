import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> toggleRecord() {
    throw UnimplementedError('toggleRecord() has not been implemented.');
  }
}
