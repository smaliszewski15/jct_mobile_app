import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ConcertPlayer {

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  //static const url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
  late String url;
  late AudioPlayer _audioPlayer;
  late int id;

  ConcertPlayer(this.id) {
    url = 'https://johncagetribute.org/api/concerts/getSongFile?id=$id';
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer.setUrl(url);
    }
    on PlayerException catch (e) {
      print("Error Code: ${e.code}");
      print("Error Message: ${e.message}");
    }
    on PlayerInterruptedException catch (e) {
      print("Conncetion aborted: ${e.message}");
    } catch (e) {
      print(e);
    }


    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed){
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void play() {
    try {
      _audioPlayer.play();
    }
    catch (e){
      print(e.toString());
    }
  }

  void pause() {
    try {
      _audioPlayer.pause();
    }
    catch (e){
      print(e.toString());
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }
}

class ProgressBarState {

  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
    });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState{
  paused, playing, loading
}
