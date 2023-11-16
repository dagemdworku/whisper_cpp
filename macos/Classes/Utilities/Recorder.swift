import Foundation
import AVFoundation

/// `Recorder` is an actor class that manages audio recording using `AVAudioRecorder`.
actor Recorder {
    // MARK: - Properties
    private var recorder: AVAudioRecorder?
    private var audioEngine: AVAudioEngine?
    private var nodeTap: Any?
    let bufferSize: AVAudioFrameCount = 1024
    
    /// Custom error type for handling recorder related errors.
    enum RecorderError: Error {
        /// Error thrown when the recording could not be started.
        case couldNotStartRecording
    }
    
    // MARK: - Methods
    
    /// Starts recording audio to the specified output file URL.
    ///
    /// - Parameters:
    ///   - url: The output file URL where the audio will be recorded.
    ///   - delegate: The delegate that will respond to recording events.
    /// - Throws: `RecorderError.couldNotStartRecording` if the recording could not be started.
    func startRecording(toOutputFile url: URL, delegate: AVAudioRecorderDelegate?, updateSamples: @MainActor @escaping (_: [Float])->()) throws {
        
        // Define the recording settings.
        let recordSettings: [String : Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // Set the audio session category and mode for non-macOS platforms.
#if !os(macOS)
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default)
#endif
        // Initialize the audio recorder.
        let recorder = try AVAudioRecorder(url: url, settings: recordSettings)
        recorder.delegate = delegate
        
        // Start recording and throw an error if it fails.
        if recorder.record() == false {
            throw RecorderError.couldNotStartRecording
        }
        
        // Store the recorder instance.
        self.recorder = recorder
        
        // Initialize and start the audio engine for real-time processing
        self.audioEngine = AVAudioEngine()
        guard let audioEngine = self.audioEngine else { return }
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        
        nodeTap = inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: inputFormat) { (buffer, time) in
            let ptr = buffer.floatChannelData![0]
            let array = Array(UnsafeBufferPointer(start: ptr, count: Int(buffer.frameLength)))
            Task {                
                await updateSamples(array)
            }
        }
        
        try audioEngine.start()
    }
    
    
    
    /// Stops the current recording if any.
    func stopRecording() {
        // Stop the recording and release the recorder instance.
        recorder = nil
        recorder?.stop()
        
        // Stop the audio engine and remove the tap
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine?.stop()
        audioEngine = nil
        nodeTap = nil
    }
}
