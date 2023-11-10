import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'whisper_cpp_platform_interface.dart';

/// An implementation of [WhisperCppPlatform] that uses method channels.
class MethodChannelWhisperCpp extends WhisperCppPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('whisper_cpp');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initialize() async {
    return await methodChannel.invokeMethod<void>('initialize');
  }
}
