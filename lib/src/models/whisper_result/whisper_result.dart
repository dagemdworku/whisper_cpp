import 'package:whisper_cpp/whisper_cpp.dart';

class WhisperResult {
  final int time;
  final int tokenBeg;
  final String text;
  final WhisperTokenData tokenData;

  WhisperResult({
    required this.time,
    required this.tokenBeg,
    required this.text,
    required this.tokenData,
  });

  factory WhisperResult.fromJson(Map<Object?, Object?>? data) {
    Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);

    return WhisperResult(
      time: IntHandler.parse(json['time']),
      tokenBeg: IntHandler.parse(json['tokenBeg']),
      text: json['text'],
      tokenData: WhisperTokenData.fromJson(json['tokenData']),
    );
  }

  WhisperResult copyWith({
    int? time,
    int? tokenBeg,
    String? text,
    WhisperTokenData? tokenData,
  }) {
    return WhisperResult(
      time: time ?? this.time,
      tokenBeg: tokenBeg ?? this.tokenBeg,
      text: text ?? this.text,
      tokenData: tokenData ?? this.tokenData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'tokenBeg': tokenBeg,
      'text': text,
      'tokenData': tokenData.toJson(),
    };
  }

  String toLog() {
    return LogHelper.parseTableContent({
      'id': tokenData.id.toString(),
      'tokenBeg': tokenBeg.toString(),
      'text': text,
      'probability': tokenData.p.toString(),
      'time offset': '${ConversionHelper.getMS(time)} ms',
      'token length': tokenData.vlen.toString(),
      'pt': tokenData.pt.toString(),
      'pt sum': tokenData.ptsum.toString(),
    });
  }

  static String toLineLog(List<WhisperResult> results) {
    return LogHelper.parseTableContent({
      'start timestamp': TimestampHelper.fromInt(results.first.time),
      'end timestamp': TimestampHelper.fromInt(results.last.time),
      'text': results.map((e) => e.text).join(),
    });
  }
}
