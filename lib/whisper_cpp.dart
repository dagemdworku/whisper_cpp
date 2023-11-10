import 'package:whisper_cpp/whisper_cpp.dart';

import 'whisper_cpp_platform_interface.dart';

export 'src/models/models.dart';
export 'src/utils/utils.dart';

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

  Future<WhisperConfig> initialize() {
    return WhisperCppPlatform.instance.initialize();
  }

  Future<void> toggleRecord() {
    return WhisperCppPlatform.instance.toggleRecord();
  }
}
