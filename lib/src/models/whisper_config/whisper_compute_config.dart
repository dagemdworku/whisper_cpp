import 'package:whisper_cpp/whisper_cpp.dart';

const int _kConsoleWidth = 79;

class WhisperComputeConfig {
  final double kvSelfSize;
  final double kvCrossSize;
  final double computeBufferConv;
  final double computeBufferEncode;
  final double computeBufferCross;
  final double computeBufferDecode;

  WhisperComputeConfig({
    required this.kvSelfSize,
    required this.kvCrossSize,
    required this.computeBufferConv,
    required this.computeBufferEncode,
    required this.computeBufferCross,
    required this.computeBufferDecode,
  });

  factory WhisperComputeConfig.fromJson(Map<Object?, Object?>? data) {
    Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);

    return WhisperComputeConfig(
      kvSelfSize: DoubleHandler.parse(json['kvSelfSize']),
      kvCrossSize: DoubleHandler.parse(json['kvCrossSize']),
      computeBufferConv: DoubleHandler.parse(json['computeBufferConv']),
      computeBufferEncode: DoubleHandler.parse(json['computeBufferEncode']),
      computeBufferCross: DoubleHandler.parse(json['computeBufferCross']),
      computeBufferDecode: DoubleHandler.parse(json['computeBufferDecode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kvSelfSize': kvSelfSize,
      'kvCrossSize': kvCrossSize,
      'computeBufferConv': computeBufferConv,
      'computeBufferEncode': computeBufferEncode,
      'computeBufferCross': computeBufferCross,
      'computeBufferDecode': computeBufferDecode,
    };
  }

  String toLog() {
    int columnWidth = (_kConsoleWidth ~/ 2) - 3;

    String logConfig = [
      ['kv self size', ConversionHelper.getMB(kvSelfSize)],
      ['kv cross size', ConversionHelper.getMB(kvCrossSize)],
      ['compute buffer (conv)', ConversionHelper.getMB(computeBufferConv)],
      ['compute buffer (encode)', ConversionHelper.getMB(computeBufferEncode)],
      ['compute buffer (cross)', ConversionHelper.getMB(computeBufferCross)],
      ['compute buffer (decode)', ConversionHelper.getMB(computeBufferDecode)]
    ].map((item) {
      return '| ${item[0].padRight(columnWidth)} | ${('${item[1]} MB').padRight(columnWidth)} |';
    }).join('\n');

    String logMessage = '\n';
    logMessage += '+${''.padRight(columnWidth + 2, '-')}+'
        '${''.padRight(columnWidth + 2, '-')}+\n';
    logMessage += logConfig;
    logMessage += '\n+${''.padRight(columnWidth + 2, '-')}+'
        '${''.padRight(columnWidth + 2, '-')}+';

    return logMessage;
  }
}
