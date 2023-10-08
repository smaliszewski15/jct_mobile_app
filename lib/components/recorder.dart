import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

const int tRSampleRate = 32000;

class Recorder {

  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool mRecorderIsInited = false;
  bool isRecording = false;

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await mRecorder!.openRecorder();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  Future<void>? stopRecorder() async {
    await mRecorder!.stopRecorder();
    return;
  }

  Recorder() {
    _init();
  }

  _init() {
    _openRecorder().then((value) {
        mRecorderIsInited = true;
    });
  }

  void release() async {
    await stopRecorder();
    await mRecorder!.closeRecorder();
    mRecorder = null;
  }

  Future<void> record(StreamController<Food> recordingDataController) async {
    await mRecorder!.startRecorder(
      codec: Codec.pcm16,
      toStream: recordingDataController.sink,
      sampleRate: tRSampleRate,
      numChannels: 1,
    );
  }
}
