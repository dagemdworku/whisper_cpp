import 'package:whisper_cpp/whisper_cpp.dart';


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
    return LogHelper.parseTableContent({
      'kv self size': '${ConversionHelper.getMB(kvSelfSize)} MB',
      'kv cross size': '${ConversionHelper.getMB(kvCrossSize)} MB',
      'compute buffer (conv)': '${ConversionHelper.getMB(computeBufferConv)} MB',
      'compute buffer (encode)': '${ConversionHelper.getMB(computeBufferEncode)} MB',
      'compute buffer (cross)': '${ConversionHelper.getMB(computeBufferCross)} MB',
      'compute buffer (decode)': '${ConversionHelper.getMB(computeBufferDecode)} MB',
    });
  }
}
