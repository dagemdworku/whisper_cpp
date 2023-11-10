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
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    @MainActor private func initialize(){
        whisperState = WhisperState()
    }
}
