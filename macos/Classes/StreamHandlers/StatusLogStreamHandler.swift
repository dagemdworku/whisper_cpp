import FlutterMacOS

import Foundation
import Combine

class StatusLogStreamHandler: NSObject, FlutterStreamHandler {
    private var flutterEventSink: FlutterEventSink?
    private var statusLogStateCancellable: AnyCancellable?
    private let whisperState: WhisperState
    
    init(whisperState: WhisperState) {
        self.whisperState = whisperState
    }
    
    @MainActor
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        flutterEventSink = events
        
        statusLogStateCancellable = whisperState.$statusLog.sink { newValue in
            self.flutterEventSink?(newValue)
        }
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        flutterEventSink = nil
        statusLogStateCancellable?.cancel()
        statusLogStateCancellable = nil
        return nil
    }
}