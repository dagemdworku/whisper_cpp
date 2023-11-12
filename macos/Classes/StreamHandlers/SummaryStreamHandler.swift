import FlutterMacOS

import Foundation
import Combine

class SummaryStreamHandler: NSObject, FlutterStreamHandler {
    private var flutterEventSink: FlutterEventSink?
    private var resultStateCancellable: AnyCancellable?
    private let whisperState: WhisperState
    
    init(whisperState: WhisperState) {
        self.whisperState = whisperState
    }
    
    @MainActor
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        flutterEventSink = events
        
        resultStateCancellable = whisperState.$summary.sink { newValue in
            self.flutterEventSink?(newValue?.toDictionary())
        }
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        flutterEventSink = nil
        resultStateCancellable?.cancel()
        resultStateCancellable = nil
        return nil
    }
}
