import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../APIfunctions/api_globals.dart';
import '../components/player.dart';
import '../components/socket_listener.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

final Uint8List silence = Uint8List(5000);

class ListenScreen extends StatefulWidget {

  @override
  _ListenScreenState createState() => _ListenScreenState();
}

class _ListenScreenState extends State<ListenScreen> {
  final buttonNotifier = ValueNotifier<bool>(false);
  SocketConnect? socket;

  final Player _mPlayer = Player();
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

  Future<void> connectListenSocket() async {
    socket = SocketConnect(SocketType.listener);
    socket!.socket.stream.listen(
          (data) {
        print(data);
        Uint8List music = data;
        _mPlayer.mPlayer!.foodSink!.add(FoodData(music.sublist(1)));
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
    _mPlayer.release();
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
    _mPlayer.isPlaying = false;
    return;
  }

  Future<void> listen() async {
    connectListenSocket();

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
                  'You are a listener. Click the connect button to connect to the socket, then wait for a concert to start.',
                  style: TextStyle(
                    fontSize: headingFontSize,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: white,
                  shape: BoxShape.circle,
                ),
                child: TextButton(
                  onPressed: () async {
                    if (!connectedForListen) {
                      await listen();
                      await connectListenSocket();
                      connectedForListen = true;
                    } else {
                      print('disconnect socket');
                      await disconnect();
                      await stopPlayer();
                      connectedForListen = false;
                    }
                    setState((){});
                  },
                  child: const Icon(
                    Icons.link,
                    color: black,
                    size: bottomIconSize + 20,
                  ),
                ),
              ),
              Text(
                  !connectedForListen ? 'Disconnect' : 'Connect',
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
