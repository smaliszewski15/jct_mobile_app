import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../APIfunctions/api_globals.dart';
import '../components/audio_wavepainter.dart';
import '../components/player.dart';
import '../components/recorder.dart';
import '../components/socket_listener.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class PerformerScreen extends StatefulWidget {
  late final String passcode;

  PerformerScreen({required this.passcode});

  @override
  _PerformerScreenState createState() => _PerformerScreenState();
}

class _PerformerScreenState extends State<PerformerScreen> {
  final buttonNotifier = ValueNotifier<bool>(false);
  SocketConnect? performSocket;

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
  }

  @override
  void dispose() {
    release();
    super.dispose();
  }

  Future<void> connectPerformSocket() async {
    performSocket = SocketConnect(SocketType.performer, user.username != '' ? user.username : 'Anonymous User', widget.passcode);
    isConnected = true;
    performSocket!.socket.stream.listen(
      (data) {
        String s = splitHeader(data);
        List<String> split = s.split(':');
        if (split[0] == 'participants') {
          parseParticipants(split[1]);
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
        disconnect();
        print('done');
      },
      onError: (error) => print(error),
    );
    setState(() {});
  }

  Future<void> disconnect() async {
    if (performSocket != null) {
      performSocket!.disconnect();
    }
    performSocket = null;
    participants = [];
    isConnected = false;
    setState(() {});
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

  Future<void> stopEverything() async {
    await stopRecorder();
    await stopPlayer();
    disconnect();
    started = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var leave = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Enter your passcode to join the session"),
                shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 15,
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Leave',
                      style: TextStyle(color: Colors.red, fontSize: 18),
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
        if (!user.logged) {
          user.username = '';
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
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
                    style: TextStyle(
                      fontSize: headingFontSize,
                      color: textColor,
                    ),
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
                            style: defaultTextStyle,
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
                    style: TextStyle(
                      fontSize: headingFontSize,
                      color: textColor,
                    ),
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
