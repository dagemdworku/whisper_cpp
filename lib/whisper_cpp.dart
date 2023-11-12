import 'dart:io';

import 'package:whisper_cpp/whisper_cpp.dart';

import 'whisper_cpp_platform_interface.dart';

export 'src/enums/all.dart';
export 'src/models/models.dart';
export 'src/utils/utils.dart';

class WhisperCpp {
  

  static Stream<bool> get isRecording {
    return WhisperCppPlatform.instance.isRecording;
  }

  static Stream<String> get statusLog {
    return WhisperCppPlatform.instance.statusLog;
  }

  static Stream<WhisperResult?> get result {
    return WhisperCppPlatform.instance.result;
  }

  static Stream<List<WhisperResult>> get results {
    return ResultStreamHandler(result).whisperResultStream;
  }

  static Stream<WhisperSummary?> get summary {
    return WhisperCppPlatform.instance.summary;
  }

  Future<String?> getPlatformVersion() {
    return WhisperCppPlatform.instance.getPlatformVersion();
  }

  Future<WhisperConfig> initialize({
    String modelName = 'ggml-tiny.en',
    bool isDebug = false,
  }) {
    if (Platform.isMacOS || Platform.isIOS) {
      return WhisperCppPlatform.instance.initialize(
        modelName: modelName,
        isDebug: isDebug,
      );
    }
    throw WhisperCppException.platformNotSupported();
  }

  Future<void> toggleRecord() {
    if (Platform.isMacOS || Platform.isIOS) {
      return WhisperCppPlatform.instance.toggleRecord();
    }
    throw WhisperCppException.platformNotSupported();
  }
}
