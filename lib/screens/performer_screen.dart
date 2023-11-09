import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:wakelock/wakelock.dart';

import '../APIfunctions/api_globals.dart';
import '../components/audio_wavepainter.dart';
import '../utils/player.dart';
import '../utils/recorder.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/socketPerformer.dart';
import '../models/user.dart';

class PerformerScreen extends StatefulWidget {
  late final String passcode;

  PerformerScreen({required this.passcode});

  @override
  _PerformerScreenState createState() => _PerformerScreenState();
}

class _PerformerScreenState extends State<PerformerScreen> with WidgetsBindingObserver {
  final buttonNotifier = ValueNotifier<bool>(false);
  SocketPerformer? performSocket;

  final Player _mPlayer = Player();
  final Recorder _mRecorder = Recorder();
  StreamSubscription? _mRecordingDataSubscription;
  StreamController? audio;
  bool muted = false;
  bool started = false;
  List<String> participants = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    connectPerformSocket();
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
        if (performSocket == null) {
          connectPerformSocket();
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

  Future<void> connectPerformSocket() async {
    performSocket = SocketPerformer(user.username != '' ? user.username : 'Anonymous User', widget.passcode);
    isConnected = true;
    performSocket!.socket.stream.listen(
      (data) {
        String s = splitHeader(data);
        List<String> split = s.split(':');
        if (split.length > 1) {
          parseParticipants(split.sublist(1).join(':'));
          print(s);
          setState(() {});
        } else {
          if (s == 'start') {
            print(s);
            record();
            listenForSink();
          } else if (s == 'stop') {
            print(s);
            stopRecorder();
            stopPlayer();
            disconnect();
            Navigator.pop(context);
            setState(() {});
          } else {
            print(data);
            if (!muted) {
              Uint8List music = data;
              _mPlayer.mPlayer!.foodSink!.add(FoodData(music.sublist(1)));
            }
          }
        }
      },
      onDone: () {
        stopEverything();
        print('done');
      },
      onError: (error) => print(error),
    );
    Wakelock.enable();
    setState(() {});
  }

  Future<void> stopEverything() async {
    await stopRecorder();
    await stopPlayer();
    disconnect();
    Wakelock.disable();
    started = false;
  }

  Future<void> disconnect() async {
    if (performSocket != null) {
      performSocket!.disconnect();
    }
    performSocket = null;
    participants = [];
    isConnected = false;
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
    return;
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
    return;
  }

  Future<void> record() async {
    audio = StreamController<Uint8List>();
    var recordingDataController = StreamController<Food>();
    _mRecorder.mRecorder!
        .setSubscriptionDuration(const Duration(milliseconds: 100));
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        if (buffer.data != null) {
          performSocket!.socket.sink.add(musicHeader(buffer.data!));
          var newData = Uint8List.fromList(buffer.data!);
          audio!.add(newData);
        }
      }
    });

    await _mRecorder.record(recordingDataController);
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
                    'Are you sure you want to leave? The session hasn\'t finished yet',
                    style: defaultTextStyle,
                  ),
                );
              }
          );
          if (leave != true) {
            return false;
          }
          stopEverything();
        }
        if (!user.logged) {
          user.username = '';
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
                    'You are the performer. The performance will start once the leader hits start.'
                        '\n\nYou can choose to hear the playback or not by clicking the mute playback button',
                    style: headingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                if (!isConnected)
                  Container(
                      width: 100,
                      height: 100,
                      child: TextButton(
                        onPressed: () async {
                          await connectPerformSocket();
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
                    'Could not connect! Tap the microphone to reconnect',
                    style: defaultTextStyle,
                    textAlign: TextAlign.center,
                  ),
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
                    style: headingTextStyle,
                    textAlign: TextAlign.center,
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
