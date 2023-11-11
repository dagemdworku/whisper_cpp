import 'package:whisper_cpp/whisper_cpp.dart';

class WhisperCppException implements Exception {
  final String code;
  final String message;
  final String tips;

  WhisperCppException({
    required this.code,
    required this.message,
    required this.tips,
  });

  @override
  String toString() {
    return 'WhisperCppException: $message (code: $code, tips: $tips)';
  }

  static WhisperCppException mapToWhisperCppException(String code) {
    return _getException(
      WhisperCppExceptionErrorCodeExtension.fromString(code),
    );
  }

  static WhisperCppException platformNotSupported() {
    return _getException(WhisperCppExceptionErrorCode.platformNotSupported);
  }

  static WhisperCppException _getException(WhisperCppExceptionErrorCode code) {
    String message;
    String tips;

    switch (code) {
      case WhisperCppExceptionErrorCode.modelNotFound:
        message = 'Model not found';
        tips =
            'Please check if the model file exists and is in the correct location';
        break;
      case WhisperCppExceptionErrorCode.alreadyInitialized:
        message = 'Already initialized';
        tips = 'Please check if you have already initialized the plugin';
        break;
      case WhisperCppExceptionErrorCode.notInitialized:
        message = 'Not initialized';
        tips = 'Please ensure you have initialized the plugin before using it';
        break;
      case WhisperCppExceptionErrorCode.platformNotSupported:
        message = 'Platform not supported';
        tips =
            'Platform not supported. Currently only macOS and iOS are supported';
        break;
      default:
        message = 'Unknown error occurred';
        tips = 'Please check your setup';
    }

    return WhisperCppException(code: code.value, message: message, tips: tips);
  }
}
