import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:wakelock/wakelock.dart';

import '../APIfunctions/api_globals.dart';
import '../components/player.dart';
import '../components/socket_listener.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

final Uint8List silence = Uint8List(5000);

class ListenScreen extends StatefulWidget {
  late final String passcode;

  ListenScreen({required this.passcode});

  @override
  _ListenScreenState createState() => _ListenScreenState();
}

class _ListenScreenState extends State<ListenScreen> {
  final buttonNotifier = ValueNotifier<bool>(false);
  SocketConnect? socket;

  final Player _mPlayer = Player();
  bool muted = false;
  bool started = false;
  List<String> participants = [];

  @override
  void initState() {
    super.initState();
    connectListenSocket();
  }

  @override
  void dispose() {
    release();
    socket!.disconnect();
    super.dispose();
  }

  Future<void> connectListenSocket() async {
    socket = SocketConnect(SocketType.listener, '', widget.passcode);
    socket!.socket.stream.listen(
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
              } else if (s == 'stop') {
                print(s);
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
    Wakelock.enable();
    setState(() {});
  }

  Future<void> disconnect() async {
    if (socket != null) {
      socket!.disconnect();
    }
    socket = null;
    Wakelock.disable();
    setState(() {});
  }

  Future<void> release() async {
    _mPlayer.release();
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
    _mPlayer.isPlaying = false;
    return;
  }

  Future<void> listen() async {
    await _mPlayer.listen();
    _mPlayer.mPlayer!.foodSink!.add(FoodData(silence));
    _mPlayer.isPlaying = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _mPlayer.stopPlayer();
        disconnect();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
        ),
        body: Container(
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
                    'You are a listener. You can choose to mute the concert if you wish.',
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
                    style: headingTextStyle,
                    textAlign: TextAlign.center,
                  ),
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
