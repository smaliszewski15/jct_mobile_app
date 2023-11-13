import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:wakelock/wakelock.dart';

import '../APIfunctions/api_globals.dart';
import '../APIfunctions/groupsAPI.dart';
import '../components/audio_wavepainter.dart';
import '../utils/player.dart';
import '../utils/recorder.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/socketMaestro.dart';
import '../models/user.dart';

class MaestroScreen extends StatefulWidget {
  late final String passcode;

  MaestroScreen({required this.passcode});

  @override
  _MaestroScreenState createState() => _MaestroScreenState();
}

class _MaestroScreenState extends State<MaestroScreen> with WidgetsBindingObserver{
  final buttonNotifier = ValueNotifier<bool>(false);
  SocketMaestro? socket;

  final Player _mPlayer = Player();
  final Recorder _mRecorder = Recorder();
  StreamSubscription? _mRecordingDataSubscription;
  StreamController? audio;
  bool muted = false;
  List<String> participants = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    connect();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    release();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        print(state);
        stopEverything();
        break;
      case AppLifecycleState.paused:
        print(state);
        stopEverything();
        break;
      case AppLifecycleState.resumed:
        print(state);
        if (socket == null) {
          connect();
        }
        if (!_mPlayer.isPlaying) {
          listenForSink();
        }
        if (!_mRecorder.isRecording) {
          record();
        }
        break;
      default:
        return;
    }
  }

  Future<void> release() async {
    _mRecorder.release();
    _mPlayer.release();
  }

  Future<void>? stopRecorder() async {
    await _mRecorder.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
    if (audio != null) {
      audio = null;
    }
    return;
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
    return;
  }

  Future<void> connect() async {
    socket = SocketMaestro(user.username, widget.passcode);
    isConnected = true;
    socket!.socket.stream.listen(
          (data) {
        String s = splitHeader(data);
        List<String> list = s.split(':');
        if (list.length > 1) {
          parseParticipants(list.sublist(1).join(':'));
          print(s);
          setState(() {});
          return;
        }
        if (s == 'stop') {
          print(s);
          stopEverything();
          return;
        }
        if (s == 'start') {
          print(s);
          return;
        }
        if (!muted) {
          Uint8List music = data;
          _mPlayer.mPlayer!.foodSink!.add(FoodData(music.sublist(1)));
        }

      },
      onDone: () {
          stopEverything();
          print('hereDone');
          setState(() {});
      },
      onError: (error) => print(error),
    );
    setState(() {});
  }

  Future<void> stopEverything() async {
    await stopRecorder();
    await stopPlayer();
    disconnect();
    Wakelock.disable();
    setState(() {});
  }

  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket = null;
    }
    participants = [];
    isConnected = false;
  }

  Future<void> record() async {
    if (socket == null) {
      return;
    }
    audio = StreamController<Uint8List>();
    var recordingDataController = StreamController<Food>();
    _mRecorder.mRecorder!.setSubscriptionDuration(const Duration(milliseconds: 100));
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            if (buffer.data != null) {
              if (socket != null) {
                socket!.socket.sink.add(musicHeader(buffer.data!));
              }

              var newData = Uint8List.fromList(buffer.data!);
              audio!.add(newData);
            }
          }
        });

    await _mRecorder.record(recordingDataController);
    socket!.socket.sink.add(start);
    _mRecorder.isRecording = true;
    Wakelock.enable();
    setState(() {});
  }

  Future<void> listenForSink() async {
    await _mPlayer.listen();
    _mPlayer.mPlayer!.foodSink!.add(FoodData(silence));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isConnected == true) {
          var leave = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Before you leave..."),
                  shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 15,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(
                        'Cancel',
                        style: invalidTextStyle,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        'Leave',
                        style: invalidTextStyle,
                      ),
                    ),
                  ],
                  content: Text(
                    "Are you sure you want to leave? This will end the session for all of the participants",
                    style: defaultTextStyle,
                  ),
                );
              }
          );
          if (leave != true) {
            return false;
          }
          socket!.socket.sink.add(stop);
          stopEverything();
          passcodes = [];
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.navigate_before, color: accentColor),
            iconSize: 35,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: mainSchemeColor,
        ),
        body: Container(
            width: double.infinity,
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
                      'You are the maestro. Click the start recording when you wish to begin.',
                      style: headingTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  if (participants.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: participants.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                              color: accentColor,
                            ),
                            child: Text(
                              participants[index],
                              style: whiteDefaultTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  if (!isConnected)
                    Container(
                      width: 100,
                      height: 100,
                      child: TextButton(
                        onPressed: () async {
                          await connect();
                        },
                        child: const Icon(
                          Icons.link,
                          color: black,
                          size: bottomIconSize + 20,
                        ),
                      )
                    ),
                  if (!isConnected)
                    Text(
                      'You are not currently connected. Tap the link button to connect.',
                      style: defaultTextStyle,
                      textAlign: TextAlign.center,
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
                          return;
                        }
                        if (_mRecorder.isRecording) {
                          socket!.socket.sink.add(stop);
                          await stopEverything();
                          passcodes = [];
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } else {
                          if (!isConnected) {
                            await connect();
                          }
                          await record();
                          await listenForSink();
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
                  if (_mRecorder.isRecording)
                    StreamBuilder(
                      stream: audio!.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) return Container();

                        final buffer = snapshot.data.buffer.asInt16List();

                        return Container(
                          width: double.infinity,
                          height: 200,
                          child: CustomPaint(
                            painter: AudioWaveForms(
                              waveData: buffer,
                              color: black,
                              numSamples: buffer.length,
                              gap: 2,
                            ),
                            child: Container(),
                          ),
                        );
                      },
                    ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
    );
  }

  void parseParticipants(String participantsList) {
    participants = participantsList.split('`').sublist(1);
    print(participants);
  }
}
