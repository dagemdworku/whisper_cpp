struct WhisperResult {
    var time: Int64
    var tokenBeg: Int64
    var text: String
    var tokenData: WhisperTokenData

    init(result: whisper_result) {
        self.time = result.time
        self.tokenBeg = result.token_beg
        self.text = String.init(cString: result.text)
        self.tokenData = WhisperTokenData(token_data: result.token_data)
    }

    func toDictionary() -> [String: Any] {
        return [
            "time": self.time,
            "tokenBeg": self.tokenBeg,
            "text": self.text,
            "tokenData": self.tokenData.toDictionary()
        ]
    }
}
