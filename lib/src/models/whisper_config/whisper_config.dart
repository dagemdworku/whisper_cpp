import 'package:whisper_cpp/whisper_cpp.dart';

class WhisperConfig {
  final WhisperModelConfig modelConfig;
  final WhisperComputeConfig computeConfig;

  WhisperConfig({
    required this.modelConfig,
    required this.computeConfig,
  });

  factory WhisperConfig.fromJson(Map<Object?, Object?>? data) {
    Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);

    return WhisperConfig(
      modelConfig: WhisperModelConfig.fromJson(json['modelConfig']),
      computeConfig: WhisperComputeConfig.fromJson(json['computeConfig']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modelConfig': modelConfig.toJson(),
      'computeConfig': computeConfig.toJson(),
    };
  }

  String toLog() {
    String logMessage = '\n';
    logMessage += '${LogHelper.getHeader()}\n';
    logMessage += LogHelper.parseTableHeader('model config');
    logMessage += modelConfig.toLog();
    logMessage += '\n';
    logMessage += LogHelper.parseTableHeader('compute config');
    logMessage += computeConfig.toLog();

    return logMessage;
  }
}
