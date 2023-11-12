import Foundation

struct WhisperTokenData {
    var id: Int32
    var tid: Int32
    var p: Float
    var plog: Float
    var pt: Float
    var ptsum: Float
    var t0: Int64
    var t1: Int64
    var vlen: Float

    init(token_data: whisper_token_data) {
        self.id = token_data.id
        self.tid = token_data.tid
        self.p = token_data.p
        self.plog = token_data.plog
        self.pt = token_data.pt
        self.ptsum = token_data.ptsum
        self.t0 = token_data.t0
        self.t1 = token_data.t1
        self.vlen = token_data.vlen
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": self.id,
            "tid": self.tid,
            "p": self.p,
            "plog": self.plog,
            "pt": self.pt,
            "ptsum": self.ptsum,
            "t0": self.t0,
            "t1": self.t1,
            "vlen": self.vlen
        ]
    }
}
