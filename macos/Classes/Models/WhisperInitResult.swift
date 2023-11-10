import Foundation

struct WhisperConfig {
    var context: OpaquePointer
    var whisperContext: WhisperContext
    var modelConfig: WhisperModelConfig
    var computeConfig: WhisperComputeConfig
}