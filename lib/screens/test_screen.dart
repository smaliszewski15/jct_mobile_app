import 'dart:async';
import 'dart:math';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';

import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

enum Command {
  start,stop,change,
}

const AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;

class TestScreen extends StatefulWidget {

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver{

  Stream? stream;
  late StreamSubscription listener;

  Random rng = new Random();

  Color _iconColor = white;
  bool isRecording = false;
  bool memRecordingState = false;
  late bool isActive;
  DateTime? startTime;

  @override
  void initState() {
    print("Init application");
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  void _controlMicStream({Command command: Command.change}) async {
    switch (command) {
      case Command.change:
        _changeListening();
        break;
      case Command.start:
        _startListening();
        break;
      case Command.stop:
        _stopListening();
        break;
    }
  }

  Future<bool> _changeListening() async => !isRecording ? await _startListening() : _stopListening();

  Future<bool> _startListening() async {
    print("START LISTENING");
    if (isRecording) return false;

    print("wait for stream");

    MicStream.shouldRequestPermission(true);
    stream = await MicStream.microphone(
      audioSource: AudioSource.DEFAULT,
      sampleRate: 48000,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
      audioFormat: AUDIO_FORMAT
    );

    setState(() {
      isRecording = true;
      startTime = DateTime.now();
    });
    return true;
  }

  bool _stopListening() {
    if (!isRecording) return false;

    setState(() {
      isRecording = false;
      startTime = null;
    });
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isActive = true;

      _controlMicStream(
          command: memRecordingState ? Command.start : Command.stop
      );
    } else if (isActive) {
      memRecordingState = isRecording;
      _controlMicStream(command: Command.stop);

      isActive = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Icon _getIcon() => (isRecording) ? Icon(Icons.stop) : Icon(Icons.keyboard_voice);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          IconButton(
              onPressed: _controlMicStream,
              icon: _getIcon(),
          ),
          Text (
            isRecording ? "Stop Recording" : "Start Recording",
            style: TextStyle(
              fontSize: bioTextSize,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          )
        ]
      )
    );
  }
}