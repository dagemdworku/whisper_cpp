import 'dart:async';

import 'package:whisper_cpp/whisper_cpp.dart';

class ResultStreamHandler {
  final StreamController<List<WhisperResult>> _controller =
      StreamController<List<WhisperResult>>();

  Stream<List<WhisperResult>> get whisperResultStream => _controller.stream;

  final List<WhisperResult> _results = [];

  int _lastTimestamp = 0;

  ResultStreamHandler(Stream<WhisperResult?> resultStream) {
    resultStream.listen((WhisperResult? result) {
      if (result == null) return;

      if (result.time.isNegative) {
        result = result.copyWith(time: _lastTimestamp);
      }

      append(result);
    });
  }

  void append(WhisperResult result) {
    _results.add(result);

    if (result.tokenData.id > result.tokenBeg) {
      _lastTimestamp = result.time;

      _controller.add([..._results]);
      _results.clear();
    }
  }

  void dispose() {
    _controller.close();
  }
}
