import Foundation

// Define custom error for Whisper
enum WhisperError: Error {
    case couldNotInitializeContext
}

// Actor for handling Whisper context
// Ensures thread safety as per Whisper's C++ constraint
actor WhisperContext {
    private var context: OpaquePointer
    
    // Initialize with context
    init(context: OpaquePointer) {
        self.context = context
    }
    
    // Deinitialize and free context
    deinit {
        whisper_free(context)
    }
    
    // Function to transcribe samples
    // Uses a maximum of 8 threads, leaving 2 processors free
    func fullTranscribe(samples: [Float]) {
        // Leave 2 processors free (i.e. the high-efficiency cores).
        let maxThreads = max(1, min(8, cpuCount() - 2))
        print("Selecting \(maxThreads) threads")
        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        "en".withCString { en in
            // Adapted from whisper.objc
            params.print_realtime = true
            params.print_progress = false
            params.print_timestamps = true
            params.print_special = false
            params.translate = false
            params.language = en
            params.n_threads = Int32(maxThreads)
            params.offset_ms = 0
            params.no_context = true
            params.single_segment = false
            
            whisper_reset_timings(context)
            print("About to run whisper_full")
            samples.withUnsafeBufferPointer { samples in
                if (whisper_full(context, params, samples.baseAddress, Int32(samples.count), logCallback) != 0) {
                    print("Failed to run the model")
                } else {
                    whisper_print_timings(context)
                }
            }
        }
    }

    // Function to initialize stream with samples
    // Uses a maximum of 8 threads, leaving 2 processors free
    func initialiseStream(samples: [Float]) {
        // Leave 2 processors free (i.e. the high-efficiency cores).
        let maxThreads = max(1, min(8, cpuCount() - 2))
        print("Selecting \(maxThreads) threads")
        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        "en".withCString { en in
            // Adapted from whisper.objc
            params.print_realtime = true
            params.print_progress = false
            params.print_timestamps = true
            params.print_special = false
            params.translate = false
            params.language = en
            params.n_threads = Int32(maxThreads)
            params.offset_ms = 0
            params.no_context = true
            params.single_segment = false
            
            whisper_reset_timings(context)
            print("About to run whisper_full")
            samples.withUnsafeBufferPointer { samples in
                if (whisper_full(context, params, samples.baseAddress, Int32(samples.count), logCallback) != 0) {
                    print("Failed to run the model")
                } else {
                    whisper_print_timings(context)
                }
            }
        }
    }
    
    typealias WhisperTranscriptionLogCallback = @convention(c) (UnsafePointer<CChar>) -> Void
    
    let logCallback: whisper_transcription_log_callback = { message in
        let log = String.init(cString: message!)
        print("Log from whisper_full: \(log)")
    }
    
    // Function to get transcription
    // Concatenates all segments of the transcription
    func getTranscription(updateTranscription: (String) -> Void) -> String {
        var data = ""
        transcription = ""
        for i in 0..<whisper_full_n_segments(context) {
            print("Received value 1: \(String.init(cString: whisper_full_get_segment_text(context, i)))")
            data += String.init(cString: whisper_full_get_segment_text(context, i))
        }
        return data
    }
    
    // Static function to create a new WhisperContext
    // Throws an error if the context could not be initialized
    static func createContext(path: String) throws -> WhisperContext {
        let context = whisper_init_from_file(path)
        if let context {
            return WhisperContext(context: context)
        } else {
            print("Couldn't load model at \(path)")
            throw WhisperError.couldNotInitializeContext
        }
    }
}

// Helper function to get the number of CPUs
fileprivate func cpuCount() -> Int {
    ProcessInfo.processInfo.processorCount
}
