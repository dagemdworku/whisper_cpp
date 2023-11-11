import Foundation

struct WhisperComputeConfig {
    var kvSelfSize: Float
    var kvCrossSize: Float
    var computeBufferConv: Float
    var computeBufferEncode: Float
    var computeBufferCross: Float
    var computeBufferDecode: Float
    
    init(compute_config: whisper_compute_config) {
        self.kvSelfSize = compute_config.kv_self_size
        self.kvCrossSize = compute_config.kv_cross_size
        self.computeBufferConv = compute_config.compute_buffer_conv
        self.computeBufferEncode = compute_config.compute_buffer_encode
        self.computeBufferCross = compute_config.compute_buffer_cross
        self.computeBufferDecode = compute_config.compute_buffer_decode
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "kvSelfSize": self.kvSelfSize,
            "kvCrossSize": self.kvCrossSize,
            "computeBufferConv": self.computeBufferConv,
            "computeBufferEncode": self.computeBufferEncode,
            "computeBufferCross": self.computeBufferCross,
            "computeBufferDecode": self.computeBufferDecode
        ]
    }
}
