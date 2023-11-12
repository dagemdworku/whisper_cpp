import 'package:whisper_cpp/whisper_cpp.dart';

class WhisperSummary {
  int tSampleUs;
  int nSample;
  int tEncodeUs;
  int nEncode;
  int tDecodeUs;
  int nDecode;
  int tPromptUs;
  int nPrompt;
  int tStartUs;
  int tEndUs;
  int nFailP;
  int nFailH;
  int tLoadUs;
  int tMelUs;

  WhisperSummary({
    required this.tSampleUs,
    required this.nSample,
    required this.tEncodeUs,
    required this.nEncode,
    required this.tDecodeUs,
    required this.nDecode,
    required this.tPromptUs,
    required this.nPrompt,
    required this.tStartUs,
    required this.tEndUs,
    required this.nFailP,
    required this.nFailH,
    required this.tLoadUs,
    required this.tMelUs,
  });

  double get sampleTimePerRun => tSampleUs / 1000.0 / nSample;
  double get encodeTimePerRun => tEncodeUs / 1000.0 / nEncode;
  double get decodeTimePerRun => tDecodeUs / 1000.0 / nDecode;
  double get promptTimePerRun => tPromptUs / 1000.0 / nPrompt;
  double get totalTime => (tEndUs - tStartUs) / 1000.0;

  double get loadTime => tLoadUs / 1000.0;
  String get fallbacks => '$nFailP p / $nFailH h';
  double get melTime => tMelUs / 1000.0;

  factory WhisperSummary.fromJson(Map<Object?, Object?>? data) {
    Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);

    return WhisperSummary(
      tSampleUs: IntHandler.parse(json['tSampleUs']),
      nSample: IntHandler.parse(json['nSample']),
      tEncodeUs: IntHandler.parse(json['tEncodeUs']),
      nEncode: IntHandler.parse(json['nEncode']),
      tDecodeUs: IntHandler.parse(json['tDecodeUs']),
      nDecode: IntHandler.parse(json['nDecode']),
      tPromptUs: IntHandler.parse(json['tPromptUs']),
      nPrompt: IntHandler.parse(json['nPrompt']),
      tStartUs: IntHandler.parse(json['tStartUs']),
      tEndUs: IntHandler.parse(json['tEndUs']),
      nFailP: IntHandler.parse(json['nFailP']),
      nFailH: IntHandler.parse(json['nFailH']),
      tLoadUs: IntHandler.parse(json['tLoadUs']),
      tMelUs: IntHandler.parse(json['tMelUs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tSampleUs': tSampleUs,
      'nSample': nSample,
      'tEncodeUs': tEncodeUs,
      'nEncode': nEncode,
      'tDecodeUs': tDecodeUs,
      'nDecode': nDecode,
      'tPromptUs': tPromptUs,
      'nPrompt': nPrompt,
      'tStartUs': tStartUs,
      'tEndUs': tEndUs,
      'nFailP': nFailP,
      'nFailH': nFailH,
      'tLoadUs': tLoadUs,
      'tMelUs': tMelUs,
    };
  }
}
