
import 'whisper_cpp_platform_interface.dart';

class WhisperCpp {
  Future<String?> getPlatformVersion() {
    return WhisperCppPlatform.instance.getPlatformVersion();
  }
}
