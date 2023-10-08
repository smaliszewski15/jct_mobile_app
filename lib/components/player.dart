import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import '../components/socket_listener.dart';

const int tPSampleRate = 32000;

class Player {

  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  bool mPlayerIsInited = false;
  bool isPlaying = false;

  Future<void>? stopPlayer() {
    if (mPlayer != null) {
      return mPlayer!.stopPlayer();
    }
    isPlaying = false;
    return null;
  }

  Player() {
    _init();
  }

  _init() {
    mPlayer!.openPlayer();
    mPlayerIsInited = true;
  }

  void release() async {
    await stopPlayer();
    await mPlayer!.closePlayer();
    mPlayer = null;
  }

  Future<void> listen() async {
    isPlaying = true;
    await mPlayer!.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tPSampleRate,
    );
  }
}
