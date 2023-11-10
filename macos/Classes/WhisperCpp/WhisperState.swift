import Foundation
import SwiftUI
import AVFoundation

/// Main class for managing the state of the Whisper application.
/// This class is responsible for loading the model, managing audio recording and playback, and transcribing audio.
@MainActor
class WhisperState: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isModelLoaded = false  // Indicates if the model is loaded
    @Published var messageLog = ""  // Log of messages for debugging and user feedback
    @Published var canTranscribe = false  // Indicates if the app is ready to transcribe audio
    @Published var isRecording = false  // Indicates if the app is currently recording audio
    
    private var whisperContext: WhisperContext?  // The context for the Whisper model
    private let recorder = Recorder()  // The audio recorder
    private var recordedFile: URL? = nil  // The URL of the recorded audio file
    private var audioPlayer: AVAudioPlayer?  // The audio player for playback of recorded audio
    
    // The URL of the model file
    private var modelUrl: URL? {
        Bundle.main.url(forResource: "ggml-tiny.en", withExtension: "bin", subdirectory: nil)
    }
    
    // The URL of the sample audio file
    private var sampleUrl: URL? {
        Bundle.main.url(forResource: "jfk", withExtension: "wav", subdirectory: nil)
    }
    
    // Error type for issues with loading the model
    private enum LoadError: Error {
        case couldNotLocateModel
    }
    
    // Initialize the WhisperState
    override init() {
        super.init()
        do {
            try loadModel()
            canTranscribe = true
        } catch {
            print(error.localizedDescription)
            messageLog += "\(error.localizedDescription)\n"
        }
    }
    
    // Load the Whisper model
    private func loadModel() throws {
        messageLog += "Loading model...\n"
        if let modelUrl {
            whisperContext = try WhisperContext.createContext(path: modelUrl.path())
            messageLog += "Loaded model \(modelUrl.lastPathComponent)\n"
        } else {
            messageLog += "Could not locate model\n"
        }
    }
    
    // Transcribe the sample audio file
    func transcribeSample() async {
        if let sampleUrl {
            await transcribeAudio(sampleUrl)
        } else {
            messageLog += "Could not locate sample\n"
        }
    }
    
    // Transcribe an audio file
    private func transcribeAudio(_ url: URL) async {
        if (!canTranscribe) {
            return
        }
        guard let whisperContext else {
            return
        }
        
        do {
            canTranscribe = false
            messageLog += "Reading wave samples...\n"
            let data = try readAudioSamples(url)
            messageLog += "Transcribing data...\n"
            await whisperContext.fullTranscribe(samples: data)
            let text = await whisperContext.getTranscription()
            messageLog += "Done: \(text)\n"
        } catch {
            print(error.localizedDescription)
            messageLog += "\(error.localizedDescription)\n"
        }
        
        canTranscribe = true
    }
    
    // Read audio samples from a file
    private func readAudioSamples(_ url: URL) throws -> [Float] {
        stopPlayback()
        try startPlayback(url)
        return try RiffWaveUtils.decodeWaveFile(url)
    }
    
    // Toggle recording state
    func toggleRecord() async {
        if isRecording {
            await recorder.stopRecording()
            isRecording = false
            if let recordedFile {
                await transcribeAudio(recordedFile)
            }
        } else {
            requestRecordPermission { granted in
                if granted {
                    Task {
                        do {
                            self.stopPlayback()
                            let file = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                .appending(path: "output.wav")
                            try await self.recorder.startRecording(toOutputFile: file, delegate: self)
                            self.isRecording = true
                            self.recordedFile = file
                        } catch {
                            print(error.localizedDescription)
                            self.messageLog += "\(error.localizedDescription)\n"
                            self.isRecording = false
                        }
                    }
                }
            }
        }
    }
    
    // Request permission to record audio
    private func requestRecordPermission(response: @escaping (Bool) -> Void) {
#if os(macOS)
        response(true)
#else
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            response(granted)
        }
#endif
    }
    
    // Start audio playback
    private func startPlayback(_ url: URL) throws {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }
    
    // Stop audio playback
    private func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    // Handle audio recording errors
    nonisolated func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error {
            Task {
                await handleRecError(error)
            }
        }
    }
    
    // Handle a recording error
    private func handleRecError(_ error: Error) {
        print(error.localizedDescription)
        messageLog += "\(error.localizedDescription)\n"
        isRecording = false
    }
    
    // Handle the end of a recording
    nonisolated func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        Task {
            await onDidFinishRecording()
        }
    }
    
    // Actions to take when recording finishes
    private func onDidFinishRecording() {
        isRecording = false
    }
}