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

class MaestroScreen extends StatefulWidget {

  @override
  _MaestroScreenState createState() => _MaestroScreenState();
}

class _MaestroScreenState extends State<MaestroScreen> {
  final buttonNotifier = ValueNotifier<bool>(false);
  SocketConnect? socket;

  final Player _mPlayer = Player();
  final Recorder _mRecorder = Recorder();
  StreamSubscription? _audioDetectedSubscription;
  StreamSubscription? _mRecordingDataSubscription;
  bool audioDetected = false;
  bool muted = false;
  bool started = false;
  List<String> participants = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    release();
    disconnect();
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

  Future<void> connect() async {
    socket = SocketConnect(SocketType.maestro);
    socket!.socket.stream.listen(
          (data) {
        String s = splitHeader(data);
        print(s);
        List<String> list = s.split(':');
        if (list[0] == 'participants') {
          parseParticipants(list[1]);
          print(s);
          setState(() {});
          return;
        }
        if (s == 'stop') {
          stopRecorder();
          return;
        }
        if (!muted) {
          Uint8List music = data;
          _mPlayer.mPlayer!.foodSink!.add(FoodData(music.sublist(1)));
        }
      },
      onDone: () {
        print('done');
      },
      onError: (error) => print(error),
    );
    setState(() {});
  }

  Future<void> disconnect() async {
    if (socket != null) {
      socket!.disconnect();
    }
    socket = null;
    participants = [];
  }

  Future<void> record() async {
    if (socket == null) {
      return;
    }
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
    socket!.socket.sink.add(start);
    _mRecorder.isRecording = true;
    setState(() {});
  }

  Future<void> listenForSink() async {
    await _mPlayer.listen();
    _mPlayer.mPlayer!.foodSink!.add(FoodData(silence));
    _mPlayer.isPlaying = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await stopRecorder();
        if (socket != null) {
          disconnect();
        }
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
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Text(
                      'You are the maestro. Click the connect button to connect to the socket, then start recording to actually start recording.',
                      style: TextStyle(
                        fontSize: headingFontSize,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                  ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 6,
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
                          child: TextButton(
                            onPressed: () async {
                              if (!_mRecorder.mRecorderIsInited) {
                                audioDetected = false;
                                return;
                              }
                              if (_mRecorder.isRecording) {
                                await stopRecorder();
                                disconnect();
                                setState((){});
                                return;
                              }
                              if (socket == null) {
                                print('connect socket');
                                await connect();
                              } else {
                                print('disconnect socket');
                                await disconnect();
                              }
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.link,
                              color: black,
                              size: bottomIconSize + 20,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: Text(
                            socket != null ? 'Disconnect' : 'Connect',
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: titleFontSize,
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  if (participants.isNotEmpty)
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 150,
                        child: ListView.builder(
                          itemCount: participants.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: accentColor,
                              ),
                              child: Text(
                                participants[index],
                                style: defaultTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: black),
                  color: mainSchemeColor,
                ),
                child: TextButton(
                  onPressed: () async {
                    if (!_mRecorder.mRecorderIsInited) {
                      audioDetected = false;
                      return;
                    }
                    if (_mRecorder.isRecording) {
                      await stopRecorder();
                      await stopPlayer();
                      started = false;
                    } else {
                      await record();
                      await listenForSink();
                      started = true;
                    }
                    setState((){});
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        )
                    ),
                  ),
                  child: Text(
                    _mRecorder.isRecording ? 'Stop Recording' : 'Start Recording',
                    style: buttonTextStyle,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: black),
                  color: mainSchemeColor,
                ),
                child: TextButton(
                  onPressed: () async {
                    setState(() => muted = !muted);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                  ),
                  child: Text(
                    !muted ? 'Mute Playback' : 'Unmute Playback',
                    style: buttonTextStyle,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Text(
                  started ? 'Started!' : '',
                  style: TextStyle(
                    fontSize: headingFontSize,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void parseParticipants(String participantsList) {
    participants = participantsList.split('`');
    print(participants);
  }
}
