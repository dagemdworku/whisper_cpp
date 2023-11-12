import Foundation

struct WhisperSummary {
    var tSampleUs: Int64
    var nSample: Int32
    var tEncodeUs: Int64
    var nEncode: Int32
    var tDecodeUs: Int64
    var nDecode: Int32
    var tPromptUs: Int64
    var nPrompt: Int32
    var tStartUs: Int64
    var tEndUs: Int64
    var nFailP: Int32
    var nFailH: Int32
    var tLoadUs: Int64
    var tMelUs: Int64
    
    init(summary: whisper_summary) {
        self.tSampleUs = summary.t_sample_us
        self.nSample = summary.n_sample
        self.tEncodeUs = summary.t_encode_us
        self.nEncode = summary.n_encode
        self.tDecodeUs = summary.t_decode_us
        self.nDecode = summary.n_decode
        self.tPromptUs = summary.t_prompt_us
        self.nPrompt = summary.n_prompt
        self.tStartUs = summary.t_start_us
        self.tEndUs = summary.t_end_us
        self.nFailP = summary.n_fail_p
        self.nFailH = summary.n_fail_h
        self.tLoadUs = summary.t_load_us
        self.tMelUs = summary.t_mel_us
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "tSampleUs": self.tSampleUs,
            "nSample": self.nSample,
            "tEncodeUs": self.tEncodeUs,
            "nEncode": self.nEncode,
            "tDecodeUs": self.tDecodeUs,
            "nDecode": self.nDecode,
            "tPromptUs": self.tPromptUs,
            "nPrompt": self.nPrompt,
            "tStartUs": self.tStartUs,
            "tEndUs": self.tEndUs,
            "nFailP": self.nFailP,
            "nFailH": self.nFailH,
            "tLoadUs": self.tLoadUs,
            "tMelUs": self.tMelUs
        ]
    }
}