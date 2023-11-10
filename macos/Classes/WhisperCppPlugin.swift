import Cocoa
import FlutterMacOS

public class WhisperCppPlugin: NSObject, FlutterPlugin {
    private var whisperState: WhisperState?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "whisper_cpp", binaryMessenger: registrar.messenger)
        let instance = WhisperCppPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    @MainActor public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        case "initialize":
            initialize()
            result(nil)
        case "toggleRecord":
            toggleRecord(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    @MainActor private func initialize(){
        whisperState = WhisperState()
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
}
