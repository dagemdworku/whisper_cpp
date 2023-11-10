import Cocoa
import FlutterMacOS

let kFLTWhisperCppMethodChannelName = "plugins.dagemdworku.io/whisper_cpp"
let kFLTWhisperCppIsRecordingEvent = "whisper_cpp_is_recording_event"
let kFLTWhisperCppStatusLogEvent = "whisper_cpp_status_log_event"

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
            initialize(result: result)
        case "toggleRecord":
            toggleRecord(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    @MainActor private func initialize(result: @escaping FlutterResult){
        whisperState = WhisperState()
        
        registerIsRecordingEventChannel(whisperState: whisperState!)
        registerStatusLogEventChannel(whisperState: whisperState!)
        
        let whisperInitResultDict: [String: Any] = [
            "modelConfig": whisperState!.whisperInitResult!.modelConfig.toDictionary(),
            "computeConfig": whisperState!.whisperInitResult!.computeConfig.toDictionary()
        ]
        
        result(whisperInitResultDict)
    }
    
    @MainActor private func toggleRecord(result: @escaping FlutterResult) {
        if whisperState == nil {
            result(nil)
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
    
    private func registerIsRecordingEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppIsRecordingEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(IsRecordingStreamHandler(whisperState: whisperState))
    }
    
    private func registerStatusLogEventChannel(whisperState: WhisperState) {
        let eventChannelName = kFLTWhisperCppMethodChannelName + "/token/" + kFLTWhisperCppStatusLogEvent
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel.setStreamHandler(StatusLogStreamHandler(whisperState: whisperState))
    }
}
