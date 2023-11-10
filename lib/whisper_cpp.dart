import 'whisper_cpp_platform_interface.dart';

class WhisperCpp {
  Future<String?> getPlatformVersion() {
    return WhisperCppPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize() {
    return WhisperCppPlatform.instance.initialize();
  }

  Future<void> toggleRecord() {
    return WhisperCppPlatform.instance.toggleRecord();
  }
}
