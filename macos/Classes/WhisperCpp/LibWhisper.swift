import Foundation

// Define custom error for Whisper
enum WhisperError: Error {
    case couldNotInitializeContext
}

// Actor for handling Whisper context
// Ensures thread safety as per Whisper's C++ constraint
actor WhisperContext {
    private var context: OpaquePointer
    
    static var state: WhisperState?
    
    // Initialize with context
    init(context: OpaquePointer) {
        self.context = context
    }
    
    // Deinitialize and free context
    deinit {
        whisper_free(context)
    }
    
    @Published var result: WhisperResult?
    
    // Function to transcribe samples
    // Uses a maximum of 8 threads, leaving 2 processors free
    func fullTranscribe(samples: [Float], state: WhisperState, isDebug: Bool) -> WhisperSummary? {
        // Leave 2 processors free (i.e. the high-efficiency cores).
        let maxThreads = max(1, min(8, cpuCount() - 2))
        
        if(isDebug){
            print("Selecting \(maxThreads) threads")
        }
        
        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        
        var summary: WhisperSummary?
        
        "en".withCString { en in
            // Adapted from whisper.objc
            params.print_realtime = true
            params.print_progress = false
            params.print_timestamps = true
            params.print_special = true
            params.translate = false
            params.language = en
            params.n_threads = Int32(maxThreads)
            params.offset_ms = 0
            params.no_context = true
            params.single_segment = false
            params.suppress_non_speech_tokens = false
            params.tdrz_enable = true
            
            whisper_reset_timings(context)
            
            if(isDebug){
                print("About to run whisper_full")
            }
            
            samples.withUnsafeBufferPointer { samples in
                WhisperContext.state = state;
                
                if (whisper_full(context, params, samples.baseAddress, Int32(samples.count), logCallback) != 0) {
                    print("Failed to run the model")
                } else {
                    summary = WhisperSummary.init(summary: whisper_print_timings(context))
                }
            }
        }
        
        return summary
    }
    
    let logCallback: whisper_transcription_log_callback = { log in
        Task {
            await state?.updateResult(with: log!.pointee)
        }
    }
        
    // Function to get transcription
    // Concatenates all segments of the transcription
    func getTranscription() -> String {
        var transcription = ""
        for i in 0..<whisper_full_n_segments(context) {
            transcription += String.init(cString: whisper_full_get_segment_text(context, i))
        }
        return transcription
    }
    
    // Static function to create a new WhisperContext
    // Throws an error if the context could not be initialized
    static func createContext(path: String, isDebug: Bool) throws -> WhisperConfig {
        guard let resultOpaquePtr = whisper_init_from_file(path, isDebug) else {
            print("Couldn't load model at \(path)")
            throw WhisperError.couldNotInitializeContext
        }
        
        let resultPtr = UnsafeMutableRawPointer(resultOpaquePtr)
            .assumingMemoryBound(to: whisper_config.self)
        let result = resultPtr.pointee
        
        let context: OpaquePointer = result.context
        let modelConfig = WhisperModelConfig(model_config: result.model_config)
        let computeConfig = WhisperComputeConfig(compute_config: result.compute_config)
        
        return WhisperConfig(
            context: context,
            whisperContext:  WhisperContext(context: context),
            modelConfig: modelConfig,
            computeConfig: computeConfig
        )
    }
}

// Helper function to get the number of CPUs
fileprivate func cpuCount() -> Int {
    ProcessInfo.processInfo.processorCount
}
