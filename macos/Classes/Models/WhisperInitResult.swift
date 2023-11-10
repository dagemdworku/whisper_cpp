import Foundation

struct WhisperInitResult {
    var context: OpaquePointer
    var whisperContext: WhisperContext
    var modelConfig: WhisperModelConfig
    var computeConfig: WhisperComputeConfig
}