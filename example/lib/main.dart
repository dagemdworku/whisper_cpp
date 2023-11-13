// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
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
  final List<List<WhisperResult>> _transcription = [];

  late StreamSubscription<bool> _isRecordingStreamSubscription;
  late StreamSubscription<bool> _isModelLoadedStreamSubscription;
  late StreamSubscription<bool> _canTranscribeStreamSubscription;
  late StreamSubscription<dynamic> _statusLogStreamSubscription;
  late StreamSubscription<List<WhisperResult>> _resultsStreamSubscription;
  late StreamSubscription<WhisperSummary?> _summaryStreamSubscription;

  String _platformVersion = 'Unknown';
  bool _isRecording = false;
  bool _isModelLoaded = false;
  bool _canTranscribe = false;
  String _statusLog = '';

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

    _platformVersion = platformVersion;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Whisper Cpp Plugin $_platformVersion'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: _initialize,
                      child: const Text('Initialize'),
                    ),
                    ElevatedButton(
                      onPressed: _toggleRecord,
                      child: Text(
                        _isRecording ? 'Stop Recording' : 'Start Recording',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _canTranscribe ? _transcribe : null,
                      child: const Text('Transcribe'),
                    ),
                    TextButton(
                      onPressed: _clear,
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) =>
                      _buildTranscription(_transcription[index]),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 8.0),
                  itemCount: _transcription.length,
                ),
              ),
              const Divider(height: 0),
              SizedBox(
                height: 100.0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _statusLog,
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
                  ),
                ),
              ),
              const Divider(height: 0),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatus('isModelLoaded', _isModelLoaded),
                    _buildStatus('isRecording', _isRecording),
                    _buildStatus('canTranscribe', _canTranscribe),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(String title, bool value) {
    return Material(
      color: (value ? Colors.green : Colors.red).shade100,
      borderRadius: BorderRadius.circular(4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              value
                  ? CupertinoIcons.checkmark_alt_circle
                  : CupertinoIcons.clear_circled,
              size: 16.0,
              color: value ? Colors.green : Colors.red,
            ),
            Text(
              ' $title',
              style: const TextStyle(height: 1.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscription(List<WhisperResult> transcription) {
    String text = transcription.map((e) => e.textOnly).join().trim();
    List<String> specialCharacters =
        transcription.map((e) => e.specialCharacters).expand((e) => e).toList();
    String startTimestamp = TimestampHelper.fromInt(transcription.first.time);
    String endTimestamp = TimestampHelper.fromInt(transcription.last.time);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(text.trim()),
        const SizedBox(height: 4.0),
        Text(
          '[$startTimestamp - $endTimestamp] ${specialCharacters.join(' ')}',
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
      ],
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
      _registerResultsChangeListener();
      _registerSummaryChangeListener();
    } on WhisperCppException catch (e) {
      print('WhisperCppException code: ${e.code}');
      print('WhisperCppException message: ${e.message}');
      print('WhisperCppException tips: ${e.tips}');
      print(e.toString());
    }
  }

  Future<void> _toggleRecord() async {
    await _whisperCppPlugin.toggleRecord();
  }

  Future<void> _transcribe() async {
    await _whisperCppPlugin.transcribe();
  }

  void _clear() {
    _transcription.clear();
    setState(() {});
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
      _statusLog += '$event\n';
      setState(() {});
    });
  }

  void _registerResultsChangeListener() {
    _resultsStreamSubscription = WhisperCpp.results.listen((
      List<WhisperResult> event,
    ) {
      _transcription.add(event);
      // _result += event.map((e) => e.text).join();

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
    _resultsStreamSubscription.cancel();
    _summaryStreamSubscription.cancel();
    super.dispose();
  }
}
