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

  String _platformVersion = 'Unknown';
  bool _isRecording = false;

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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initialize() async {
    await _whisperCppPlugin.initialize();
    _registerIsRecordingChangeListener();
  }

  void _registerIsRecordingChangeListener() {
    _isRecordingStreamSubscription =
        WhisperCpp.isRecording.listen((bool event) {
      _isRecording = event;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _isRecordingStreamSubscription.cancel();
    super.dispose();
  }
}
