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
  bool connectedForListen = false;

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

  Future<void> connectPerformSocket() async {
    socket = SocketConnect(SocketType.performer);
    socket!.socket.stream.listen(
          (data) {
        String s = String.fromCharCodes(data);
        List<String> split = s.split(':');
        if (split[0] == 'participants') {
          print(s);
        } else {
          if (s == 'start') {
            print(s);
            record();
          } else {
            print(data);
            Uint8List music = data;
            _mPlayer.mPlayer!.foodSink!.add(FoodData(music.sublist(1)));
          }
        }
      },
      onDone: () {
        print('done');
      },
      onError: (error) => print(error),
    );
    connectedForListen = false;
    setState(() {});
  }

  Future<void> connectListenSocket() async {
    socket = SocketConnect(SocketType.listener);
    socket!.socket.stream.listen(
          (data) {
        String s = String.fromCharCodes(data);
        if (s == 'start') {
          print('start');
        } else {
          print(data);
          _mPlayer.mPlayer!.foodSink!.add(FoodData(data));
        }
      },
      onDone: () {
        print('done');
      },
      onError: (error) => print(error),
    );
    connectedForListen = true;
    setState(() {});
  }

  Future<void> disconnect() async {
    if (socket != null) {
      socket!.disconnect();
    }
    socket = null;
    setState(() {});
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
    /*if (connectedForListen) {
      disconnect();
      connectPerformSocket();
      connectedForListen = false;
    }
    if (_mPlayer.isPlaying) {
      stopPlayer();
    }*/

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
    listenForSink();
    setState(() {});
  }

  /*Future<void> listen() async {
    if (!connectedForListen) {
      disconnect();
      connectListenSocket();
      connectedForListen = true;
    }
    if (_mRecorder.isRecording) {
      stopRecorder();
    }
    _mPlayer.listen();

    await _mPlayer.listen();
    _mPlayer.mPlayer!.foodSink!.add(FoodData(silence));
    _mPlayer.isPlaying = true;
    setState(() {});
  }*/

  Future<void> listenForSink() async {
    /*if (_mRecorder.isRecording) {
      stopRecorder();
    }*/
    _mPlayer.listen();

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
                      disconnect();
                      setState((){});
                      return;
                    }
                    if (socket == null) {
                      print('connect socket');
                      if (_isListening) {
                        await connectListenSocket();
                      } else {
                        await connectPerformSocket();
                      }

                    } else {
                      print('disconnect socket');
                      await disconnect();
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
                  socket != null ? 'Disconnect' : 'Connect',
                  style: TextStyle(
                    color: buttonTextColor,
                    fontSize: titleFontSize,
                  )
              ),
              OutlinedButton(
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
                    //await listen();
                  } else {
                    print('going to record');
                    await record();
                    await listenForSink();
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )
                  ),
                ),
                child: Text(
                  _mRecorder.isRecording || _mPlayer.isPlaying ? 'Stop' : 'Start',
                  style: defaultTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() => _isListening = !_isListening);
                    if (_mRecorder.isRecording || _mPlayer.isPlaying) {
                      if (_isListening) {
                        //await listen();
                      } else {
                        await record();
                        await listenForSink();
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
