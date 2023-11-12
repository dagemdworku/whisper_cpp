import 'package:whisper_cpp/whisper_cpp.dart';

const int _kConsoleWidth = 79;

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

  double get sampleTimePerRun => tSampleUs / nSample;
  double get encodeTimePerRun => tEncodeUs / nEncode;
  double get decodeTimePerRun => tDecodeUs / nDecode;
  double get promptTimePerRun => tPromptUs / nPrompt;
  double get totalTime => tEndUs - tStartUs + 0.0;

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

  String toLog() {
    int columnWidth = (_kConsoleWidth ~/ 2) - 3;


    var logConfig = [
      ['load time', '${ConversionHelper.getMS(tLoadUs)} ms'],
      ['fallbacks (p/h)', '$nFailP / $nFailH'],
      ['mel time', '${ConversionHelper.getMS(tMelUs)} ms'],
      [
        'sample time / runs / time per run',
        '${'${ConversionHelper.getMS(tSampleUs)} ms'.padRight(11)} / '
        '${nSample.toString().padRight(5)} / '
        '${'${ConversionHelper.getMS(sampleTimePerRun)} ms'.padRight(12)}'
      ],
      [
        'encode time / runs / time per run',
        '${'${ConversionHelper.getMS(tEncodeUs)} ms'.padRight(11)} / '
        '${nEncode.toString().padRight(5)} / '
        '${'${ConversionHelper.getMS(encodeTimePerRun)} ms'.padRight(12)}'
      ],
      [
        'decode time / runs / time per run',
        '${'${ConversionHelper.getMS(tDecodeUs)} ms'.padRight(11)} / '
        '${nDecode.toString().padRight(5)} / '
        '${'${ConversionHelper.getMS(decodeTimePerRun)} ms'.padRight(12)}'
      ],
      [
        'prompt time / runs / time per run',
        '${'${ConversionHelper.getMS(tPromptUs)} ms'.padRight(11)} / '
        '${nPrompt.toString().padRight(5)} / '
        '${'${ConversionHelper.getMS(promptTimePerRun)} ms'.padRight(12)}'
      ],
      ['total time', '${ConversionHelper.getMS(totalTime)} ms']
    ].map((item) {
      return '| ${item[0].padRight(columnWidth)} | ${(item[1]).padRight(columnWidth)} |';
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
