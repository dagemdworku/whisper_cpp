// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:whisper_cpp/whisper_cpp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _whisperCppPlugin = WhisperCpp();

  late StreamSubscription<bool> _isRecordingStreamSubscription;
  late StreamSubscription<bool> _isModelLoadedStreamSubscription;
  late StreamSubscription<bool> _canTranscribeStreamSubscription;
  late StreamSubscription<dynamic> _statusLogStreamSubscription;
  late StreamSubscription<WhisperResult?> _resultStreamSubscription;
  late StreamSubscription<List<WhisperResult>> _resultsStreamSubscription;
  late StreamSubscription<WhisperSummary?> _summaryStreamSubscription;

  String _platformVersion = 'Unknown';
  bool _isRecording = false;
  bool _isModelLoaded = false;
  bool _canTranscribe = false;
  String _statusLog = '';
  String _result = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _whisperCppPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Is Recording: $_isRecording\n'),
              Text('Is Model Loaded: $_isModelLoaded\n'),
              Text('Can Transcribe: $_canTranscribe\n'),
              Text('Status: $_statusLog\n'),
              ElevatedButton(
                onPressed: _initialize,
                child: const Text('Initialize'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _whisperCppPlugin.toggleRecord();
                },
                child: Text(_isRecording ? 'Stop' : 'Start'),
              ),
              const Divider(),
              Text('Result: $_result\n'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initialize() async {
    try {
      WhisperConfig config = await _whisperCppPlugin.initialize(
        modelName: 'ggml-tiny.en',
        isDebug: false,
      );
      print('config: ${config.toLog()}');

      _registerIsRecordingChangeListener();
      _registerIsModelLoadedChangeListener();
      _registerCanTranscribeChangeListener();
      _registerStatusLogChangeListener();
      // _registerResultChangeListener();
      _registerResultsChangeListener();
      _registerSummaryChangeListener();
    } on WhisperCppException catch (e) {
      print('WhisperCppException code: ${e.code}');
      print('WhisperCppException message: ${e.message}');
      print('WhisperCppException tips: ${e.tips}');
      print(e.toString());
    }
  }

  void _registerIsRecordingChangeListener() {
    _isRecordingStreamSubscription =
        WhisperCpp.isRecording.listen((bool event) {
      _isRecording = event;
      setState(() {});
    });
  }

  void _registerIsModelLoadedChangeListener() {
    _isModelLoadedStreamSubscription =
        WhisperCpp.isModelLoaded.listen((bool event) {
      _isModelLoaded = event;
      setState(() {});
    });
  }

  void _registerCanTranscribeChangeListener() {
    _canTranscribeStreamSubscription =
        WhisperCpp.canTranscribe.listen((bool event) {
      _canTranscribe = event;
      setState(() {});
    });
  }

  void _registerStatusLogChangeListener() {
    _statusLogStreamSubscription = WhisperCpp.statusLog.listen((String event) {
      _statusLog = event;
      setState(() {});
    });
  }

  // void _registerResultChangeListener() {
  //   _resultStreamSubscription = WhisperCpp.result.listen((
  //     WhisperResult? event,
  //   ) {
  //     if (event == null) return;

  //     _result += event.text;
  //     if (event.tokenData.id > event.tokenBeg) _result += '\n';

  //     print('result: ${event.toLog()}');

  //     setState(() {});
  //   });
  // }

  void _registerResultsChangeListener() {
    _resultsStreamSubscription = WhisperCpp.results.listen((
      List<WhisperResult> event,
    ) {
      _result += event.map((e) => e.text).join();

      print('results: ${WhisperResult.toLineLog(event)}');
      
      setState(() {});
    });
  }

  void _registerSummaryChangeListener() {
    _summaryStreamSubscription = WhisperCpp.summary.listen((
      WhisperSummary? event,
    ) {
      if (event == null) return;
      print('summary: ${event.toLog()}');
    });
  }

  @override
  void dispose() {
    _isRecordingStreamSubscription.cancel();
    _isModelLoadedStreamSubscription.cancel();
    _canTranscribeStreamSubscription.cancel();
    _statusLogStreamSubscription.cancel();
    _resultStreamSubscription.cancel();
    _resultsStreamSubscription.cancel();
    _summaryStreamSubscription.cancel();
    super.dispose();
  }
}
