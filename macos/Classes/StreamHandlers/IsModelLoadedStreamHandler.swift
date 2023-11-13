import FlutterMacOS

import Foundation
import Combine

class IsModelLoadedStreamHandler: NSObject, FlutterStreamHandler {
    private var flutterEventSink: FlutterEventSink?
    private var recordingStateCancellable: AnyCancellable?
    private let whisperState: WhisperState
    
    init(whisperState: WhisperState) {
        self.whisperState = whisperState
    }
    
    @MainActor
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        flutterEventSink = events
        
        recordingStateCancellable = whisperState.$isModelLoaded.sink { newValue in
            self.flutterEventSink?(newValue)
        }
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        flutterEventSink = nil
        recordingStateCancellable?.cancel()
        recordingStateCancellable = nil
        return nil
    }
}
