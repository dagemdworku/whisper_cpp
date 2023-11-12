import 'package:whisper_cpp/whisper_cpp.dart';

const int _kConsoleWidth = 79;

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

  String toLog() {
    int columnWidth = (_kConsoleWidth ~/ 2) - 3;

    var logConfig = [
      ['id', tokenData.id.toString()],
      ['text', text],
      ['probability', tokenData.p.toString()],
      ['time offset', ConversionHelper.getMS(time).toString()],
      ['token length', tokenData.vlen.toString()],
      ['pt', tokenData.pt.toString()],
      ['pt sum', tokenData.ptsum.toString()],
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
