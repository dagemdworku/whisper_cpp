import 'package:whisper_cpp/whisper_cpp.dart';

const int _kConsoleWidth = 79;

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
    int columnWidth = _kConsoleWidth - 2;

    String logMessage = '\n';
    logMessage += '+${''.padRight(columnWidth, '-')}+\n';
    logMessage += '|${' model config'.padRight(columnWidth, ' ')}|';
    logMessage += modelConfig.toLog();
    logMessage += '\n|${' compute config'.padRight(columnWidth, ' ')}|';
    logMessage += computeConfig.toLog();

    return logMessage;
  }
}
