import 'package:whisper_cpp/whisper_cpp.dart';

class WhisperModelConfig {
  final int nVocab;
  final int nAudioCtx;
  final int nAudioState;
  final int nAudioHead;
  final int nAudioLayer;
  final int nTextCtx;
  final int nTextState;
  final int nTextHead;
  final int nTextLayer;
  final int nMels;
  final int ftype;
  final int qntvr;
  final int type;
  final int extraTokens;
  final double modelCtx;
  final double modelSize;

  WhisperModelConfig({
    required this.nVocab,
    required this.nAudioCtx,
    required this.nAudioState,
    required this.nAudioHead,
    required this.nAudioLayer,
    required this.nTextCtx,
    required this.nTextState,
    required this.nTextHead,
    required this.nTextLayer,
    required this.nMels,
    required this.ftype,
    required this.qntvr,
    required this.type,
    required this.extraTokens,
    required this.modelCtx,
    required this.modelSize,
  });

  factory WhisperModelConfig.fromJson(Map<Object?, Object?>? data) {
    Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);

    return WhisperModelConfig(
      nVocab: IntHandler.parse(json['nVocab']),
      nAudioCtx: IntHandler.parse(json['nAudioCtx']),
      nAudioState: IntHandler.parse(json['nAudioState']),
      nAudioHead: IntHandler.parse(json['nAudioHead']),
      nAudioLayer: IntHandler.parse(json['nAudioLayer']),
      nTextCtx: IntHandler.parse(json['nTextCtx']),
      nTextState: IntHandler.parse(json['nTextState']),
      nTextHead: IntHandler.parse(json['nTextHead']),
      nTextLayer: IntHandler.parse(json['nTextLayer']),
      nMels: IntHandler.parse(json['nMels']),
      ftype: IntHandler.parse(json['ftype']),
      qntvr: IntHandler.parse(json['qntvr']),
      type: IntHandler.parse(json['type']),
      extraTokens: IntHandler.parse(json['extraTokens']),
      modelCtx: DoubleHandler.parse(json['modelCtx']),
      modelSize: DoubleHandler.parse(json['modelSize']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nVocab': nVocab,
      'nAudioCtx': nAudioCtx,
      'nAudioState': nAudioState,
      'nAudioHead': nAudioHead,
      'nAudioLayer': nAudioLayer,
      'nTextCtx': nTextCtx,
      'nTextState': nTextState,
      'nTextHead': nTextHead,
      'nTextLayer': nTextLayer,
      'nMels': nMels,
      'ftype': ftype,
      'qntvr': qntvr,
      'type': type,
      'extraTokens': extraTokens,
      'modelCtx': modelCtx,
      'modelSize': modelSize,
    };
  }
}
