import 'dart:async';
import 'dart:typed_data';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../APIfunctions/api_globals.dart';
import '../components/player.dart';
import '../components/recorder.dart';
import '../components/socket_listener.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class MaestroScreen extends StatefulWidget {

  @override
  _MaestroScreenState createState() => _MaestroScreenState();
}

class _MaestroScreenState extends State<MaestroScreen> {
  final buttonNotifier = ValueNotifier<bool>(false);
  SocketConnect? socket;

  final Recorder _mRecorder = Recorder();
  StreamSubscription? _audioDetectedSubscription;
  StreamSubscription? _mRecordingDataSubscription;
  bool audioDetected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    release();
    socket!.disconnect();
    super.dispose();
  }

  Future<void> release() async {
    _mRecorder.release();
  }

  Future<void>? stopRecorder() async {
    await _mRecorder.stopRecorder();
    if (_audioDetectedSubscription != null) {
      await _audioDetectedSubscription!.cancel();
      _audioDetectedSubscription = null;
    }
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
    audioDetected = false;
    return;
  }

  Future<void> record() async {
    socket = SocketConnect(SocketType.maestro);

    var recordingDataController = StreamController<Food>();
    _mRecorder.mRecorder!.setSubscriptionDuration(const Duration(milliseconds: 100));
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            if (buffer.data != null) {
              socket!.socket.sink.add(musicHeader(buffer.data!));
            }
          }
        });

    _audioDetectedSubscription = _mRecorder.mRecorder!.onProgress!.listen((e) {
      if (e.decibels! > 20 && !audioDetected) {
        setState(() => audioDetected = true);
      } else if (e.decibels! < 20 && audioDetected) {
        setState(() => audioDetected = false);
      }
    });
    _mRecorder.record(recordingDataController);
    socket!.socket.sink.add(start);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await stopRecorder();
        return true;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: backgroundColor,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: audioDetected ? Colors.green : white,
                  shape: BoxShape.circle,
                ),
                child: OutlinedButton(
                  onPressed: () async {
                    if (!_mRecorder.mRecorderIsInited) {
                      audioDetected = false;
                      return;
                    }
                    if (_mRecorder.isRecording) {
                      await stopRecorder();
                      setState((){});
                      return;
                    }
                    await record();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        )
                    ),
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: black,
                    size: bottomIconSize,
                  ),
                ),
              ),
              Text(
                  _mRecorder.isRecording ? 'Stop' : 'Connect',
                  style: TextStyle(
                    color: buttonTextColor,
                    fontSize: titleFontSize,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
