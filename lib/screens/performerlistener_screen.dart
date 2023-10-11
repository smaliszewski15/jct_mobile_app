import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../APIfunctions/api_globals.dart';
import '../components/player.dart';
import '../components/recorder.dart';
import '../components/socket_listener.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

final Uint8List silence = Uint8List(5000);

class TestScreen extends StatefulWidget {

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final buttonNotifier = ValueNotifier<bool>(false);
  SocketConnect? socket;

  final Player _mPlayer = Player();
  final Recorder _mRecorder = Recorder();
  StreamSubscription? _audioDetectedSubscription;
  StreamSubscription? _mRecordingDataSubscription;
  bool _isListening = false;
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
    _mPlayer.release();
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
    _mRecorder.isRecording = false;
    return;
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
    _mPlayer.isPlaying = false;
    return;
  }

  Future<void> record() async {
    if (_mPlayer.isPlaying) {
      stopPlayer();
    }
    socket = SocketConnect(SocketType.performer);
    socket!.socket.stream.listen(
          (data) {
      },
      onDone: () {
        socket = null;
        print('done');
      },
      onError: (error) => print(error),
    );

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
    await _mRecorder.record(recordingDataController);
    _mRecorder.isRecording = true;
    setState(() {});
  }

  Future<void> listen() async {
    if (_mRecorder.isRecording) {
      stopRecorder();
    }
    socket = SocketConnect(SocketType.listener);
    _mPlayer.listen();
    socket!.socket.stream.listen(
          (data) {
            print(data);
        _mPlayer.mPlayer!.foodSink!.add(FoodData(data));
      },
      onDone: () {
          socket = null;
        print('done');
      },
      onError: (error) => print(error),
    );
    await _mPlayer.listen();
    _mPlayer.mPlayer!.foodSink!.add(FoodData(silence));
    _mPlayer.isPlaying = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _mRecorder.stopRecorder();
        await _mPlayer.stopPlayer();
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
                    if (_mRecorder.isRecording || _mPlayer.isPlaying) {
                      await stopRecorder();
                      await stopPlayer();
                      setState((){});
                      return;
                    }
                    if (_isListening) {
                      await listen();
                    } else {
                      print('going to record');
                      await record();
                    }
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
                  _mRecorder.isRecording || _mPlayer.isPlaying ? 'Stop' : 'Connect',
                  style: TextStyle(
                    color: buttonTextColor,
                    fontSize: titleFontSize,
                  )
              ),
              Container(
                  margin: const EdgeInsets.all(15),
                  child: OutlinedButton(
                    onPressed: () async {
                      setState(() => _isListening = !_isListening);
                      if (_mRecorder.isRecording || _mPlayer.isPlaying) {
                        if (_isListening) {
                          await listen();
                        } else {
                          await record();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 150,
                          padding: const EdgeInsets.all(5),
                          color: _isListening ? black : mainSchemeColor,
                          child: Text(
                            'Record',
                            style: TextStyle(
                              color: _isListening ? white : black,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.all(5),
                          color: _isListening ? mainSchemeColor : black,
                          child: Text(
                            'Listen',
                            style: TextStyle(
                              color: _isListening ? black : white,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}