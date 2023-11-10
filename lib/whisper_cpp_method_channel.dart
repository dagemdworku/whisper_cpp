import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:whisper_cpp/whisper_cpp.dart';

import 'whisper_cpp_platform_interface.dart';

const String _kMethodChannelName = 'plugins.dagemdworku.io/whisper_cpp';
const String _kIsRecordingEvent = 'whisper_cpp_is_recording_event';
const String _kStatusLogEvent = 'whisper_cpp_status_log_event';

/// An implementation of [WhisperCppPlatform] that uses method channels.
class MethodChannelWhisperCpp extends WhisperCppPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(_kMethodChannelName);

  final EventChannel isRecordingEventChannel =
      const EventChannel('$_kMethodChannelName/token/$_kIsRecordingEvent');

  final EventChannel statusLogEventChannel =
      const EventChannel('$_kMethodChannelName/token/$_kStatusLogEvent');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<WhisperConfig> initialize() async {
    final config =
        await methodChannel.invokeMethod<Map<Object?, Object?>>('initialize');

    return WhisperConfig.fromJson(config);
  }

  @override
  Future<void> toggleRecord() async {
    return await methodChannel.invokeMethod<void>('toggleRecord');
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
}
