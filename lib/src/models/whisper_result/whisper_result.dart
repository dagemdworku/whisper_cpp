import 'package:whisper_cpp/whisper_cpp.dart';

class WhisperResult {
  final int time;
  final String text;
  final WhisperTokenData tokenData;

  WhisperResult({
    required this.time,
    required this.text,
    required this.tokenData,
  });

  factory WhisperResult.fromJson(Map<Object?, Object?>? data) {
    Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);

    return WhisperResult(
      time: IntHandler.parse(json['time']),
      text: json['text'],
      tokenData: WhisperTokenData.fromJson(json['tokenData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'text': text,
      'tokenData': tokenData.toJson(),
    };
  }
}
