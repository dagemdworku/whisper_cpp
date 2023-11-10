import 'whisper_cpp_platform_interface.dart';

class WhisperCpp {
  static Stream<bool> get isRecording {
    return WhisperCppPlatform.instance.isRecording;
  }

  static Stream<String> get statusLog {
    return WhisperCppPlatform.instance.statusLog;
  }

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
