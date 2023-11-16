import Cocoa
import FlutterMacOS

let kFLTWhisperCppMethodChannelName = "plugins.dagemdworku.io/whisper_cpp"
let kFLTWhisperCppIsRecordingEvent = "whisper_cpp_is_recording_event"
let kFLTWhisperCppIsModelLoadedEvent = "whisper_cpp_is_model_loaded_event"
let kFLTWhisperCppCanTranscribeEvent = "whisper_cpp_can_transcribe_event"
let kFLTWhisperCppStatusLogEvent = "whisper_cpp_status_log_event"
let kFLTWhisperCppResultEvent = "whisper_cpp_result_event"
let kFLTWhisperCppSummaryEvent = "whisper_cpp_summary_event"
let kFLTWhisperCppSamplesEvent = "whisper_cpp_samples_event"

public class WhisperCppPlugin: NSObject, FlutterPlugin {
    private var whisperState: WhisperState?
    
    private var messenger: FlutterBinaryMessenger
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger
        
        let channel = FlutterMethodChannel(name: kFLTWhisperCppMethodChannelName, binaryMessenger: binaryMessenger)
        let instance = WhisperCppPlugin(messenger: binaryMessenger)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    @MainActor public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        case "initialize":
            initialize(call: call, result: result)
        case "toggleRecord":
            toggleRecord(result: result)
        case "transcribe":
            transcribe(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    @MainActor private func initialize(call: FlutterMethodCall, result: @escaping FlutterResult){
        guard let arguments = call.arguments as? [String: Any] else {
            result(whisperCppError(from: WhisperCppError.configurationError))
            return
        }
        guard let modelName = arguments["modelName"] as? String else {
            result(whisperCppError(from: WhisperCppError.configurationError))
            return
        }
        guard let isDebug = arguments["isDebug"] as? Bool else {
            result(whisperCppError(from: WhisperCppError.configurationError))
            return
        }


        if whisperState == nil {
            do {
                whisperState = try WhisperState(modelName: modelName, isDebug: isDebug)
                
                let whisperConfigDict: [String: Any] = [
                    "modelConfig": whisperState!.whisperConfig!.modelConfig.toDictionary(),
                    "computeConfig": whisperState!.whisperConfig!.computeConfig.toDictionary()
                ]
                
                registerEventChannels(whisperState: whisperState);
                
                result(whisperConfigDict)
            } catch {
                result(flutterError(from: error))
            }
        } else {
            registerEventChannels(whisperState: whisperState);
            result(whisperCppError(from: WhisperCppError.alreadyInitialized))
        }
    }
    
    @MainActor private func toggleRecord(result: @escaping FlutterResult) {
        if whisperState == nil {
            result(whisperCppError(from: WhisperCppError.notInitialized))
        } else {
            Task {
                do {
                    await self.whisperState!.toggleRecord()
                    DispatchQueue.main.async {
                        result(nil)
                    }
                }
            }
        }
    }
    
    @MainActor private func transcribe(result: @escaping FlutterResult) {
        if whisperState == nil {
            result(whisperCppError(from: WhisperCppError.notInitialized))
        } else {
            Task {
                do {
                    await self.whisperState!.transcribe()
                    DispatchQueue.main.async {
                        result(nil)
                    }
                }
            }
        }
    }
    
    private func registerEventChannels(whisperState: WhisperState?){
        if(whisperState == nil) { return; }
        
        registerIsRecordingEventChannel(whisperState: whisperState!)
        registerIsModelLoadedEventChannel(whisperState: whisperState!)
        registerCanTranscribeEventChannel(whisperState: whisperState!)
        registerStatusLogEventChannel(whisperState: whisperState!)
        registerResultEventChannel(whisperState: whisperState!)
        registerSummaryEventChannel(whisperState: whisperState!)
        registerSamplesEventChannel(whisperState: whisperState!)
    }
    
    private func registerIsRecordingEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppIsRecordingEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(IsRecordingStreamHandler(whisperState: whisperState))
    }
    
    private func registerIsModelLoadedEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppIsModelLoadedEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(IsModelLoadedStreamHandler(whisperState: whisperState))
    }
    
    private func registerCanTranscribeEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppCanTranscribeEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(CanTranscribeStreamHandler(whisperState: whisperState))
    }
    
    private func registerStatusLogEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppStatusLogEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(StatusLogStreamHandler(whisperState: whisperState))
    }

    private func registerResultEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppResultEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(ResultStreamHandler(whisperState: whisperState))
    }
    
    private func registerSummaryEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppSummaryEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(SummaryStreamHandler(whisperState: whisperState))
    }

    private func registerSamplesEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppSamplesEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(SamplesStreamHandler(whisperState: whisperState))
    }
    
    private func flutterError(from error: Error) -> FlutterError {
        return FlutterError(code: error.localizedDescription, message: nil, details: nil)
    }
    
    private func whisperCppError(from error: WhisperCppError) -> FlutterError {
        return FlutterError(code: error.rawValue, message: nil, details: nil)
    }
}
