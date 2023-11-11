enum WhisperCppError: String {
    case modelNotFound = "model-not-found"
    case alreadyInitialized = "already-initialized"
    case notInitialized = "not-initialized"
    case configurationError = "configuration-error"
    // TODO: Add the rest of the error enum later
}

class WhisperCppException: NSError {
    init(error: WhisperCppError) {
        super.init(domain: "WhisperCppException", code: 0, userInfo: [NSLocalizedDescriptionKey: error.rawValue])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
