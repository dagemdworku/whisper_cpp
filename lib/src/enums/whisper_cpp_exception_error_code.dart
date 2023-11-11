enum WhisperCppExceptionErrorCode {
  modelNotFound,
  alreadyInitialized,
  notInitialized,
  platformNotSupported,
  unknown
}

const Map<WhisperCppExceptionErrorCode, String> errorCodeMap = {
  WhisperCppExceptionErrorCode.modelNotFound: 'model-not-found',
  WhisperCppExceptionErrorCode.alreadyInitialized: 'already-initialized',
  WhisperCppExceptionErrorCode.notInitialized: 'not-initialized',
  WhisperCppExceptionErrorCode.platformNotSupported: 'platform-not-supported',
  WhisperCppExceptionErrorCode.unknown: 'unknown',
};

extension WhisperCppExceptionErrorCodeExtension
    on WhisperCppExceptionErrorCode {
  String get value => errorCodeMap[this] ?? 'unknown';

  static WhisperCppExceptionErrorCode fromString(String value) {
    return errorCodeMap.entries
        .firstWhere((entry) => entry.value == value,
            orElse: () =>
                const MapEntry(WhisperCppExceptionErrorCode.unknown, 'unknown'))
        .key;
  }
}
