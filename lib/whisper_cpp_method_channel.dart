import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:whisper_cpp/whisper_cpp.dart';

import 'whisper_cpp_platform_interface.dart';

const String _kMethodChannelName = 'plugins.dagemdworku.io/whisper_cpp';
const String _kIsRecordingEvent = 'whisper_cpp_is_recording_event';
const String _kStatusLogEvent = 'whisper_cpp_status_log_event';
const String _kResultEvent = 'whisper_cpp_result_event';
const String _kSummaryEvent = 'whisper_cpp_summary_event';

/// An implementation of [WhisperCppPlatform] that uses method channels.
class MethodChannelWhisperCpp extends WhisperCppPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(_kMethodChannelName);

  final EventChannel isRecordingEventChannel =
      const EventChannel('$_kMethodChannelName/token/$_kIsRecordingEvent');

  final EventChannel statusLogEventChannel =
      const EventChannel('$_kMethodChannelName/token/$_kStatusLogEvent');

  final EventChannel resultEventChannel =
      const EventChannel('$_kMethodChannelName/token/$_kResultEvent');

  final EventChannel summaryEventChannel =
      const EventChannel('$_kMethodChannelName/token/$_kSummaryEvent');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<WhisperConfig> initialize({
    required String modelName,
  }) async {
    Map<String, dynamic> arguments = {
      'modelName': modelName,
    };

    try {
      final config = await methodChannel.invokeMethod('initialize', arguments);
      return WhisperConfig.fromJson(config);
    } on PlatformException catch (e) {
      throw WhisperCppException.mapToWhisperCppException(e.code);
    }
  }

  @override
  Future<void> toggleRecord() async {
    try {
      return await methodChannel.invokeMethod<void>('toggleRecord');
    } on PlatformException catch (e) {
      throw WhisperCppException.mapToWhisperCppException(e.code);
    }
  }

  @override
  Stream<bool> get isRecording {
    return isRecordingEventChannel.receiveBroadcastStream().map((event) {
      return event is bool ? event : false;
    });
  }

  @override
  Stream<String> get statusLog {
    return statusLogEventChannel.receiveBroadcastStream().map((event) {
      return event is String ? event : '';
    });
  }

  @override
  Stream<WhisperResult?> get result {
    return resultEventChannel.receiveBroadcastStream().map((event) {
      return event is Map ? WhisperResult.fromJson(event) : null;
    });
  }

  @override
  Stream<WhisperSummary?> get summary {
    return summaryEventChannel.receiveBroadcastStream().map((event) {
      print(event);
      return event is Map ? WhisperSummary.fromJson(event) : null;
    });
  }
}
