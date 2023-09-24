import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../APIFunctions/api_globals.dart';
//import '../components/socket_listener.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

const int tRSampleRate = 41000;
const int tPSampleRate = 41000;

class TestScreen extends StatefulWidget {

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver{
  final buttonNotifier = ValueNotifier<bool>(false);
  late WebSocketChannel? socket;

  void disconnect() {
    socket!.sink.add('disconnect');
    socket!.sink.close();
    socket = null;
    buttonNotifier.value = false;
  }

  void connect() {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080'));
    socket!.stream.listen((data) {
      _mPlayer!.foodSink!.add(FoodData(data));
    },
    onError: (error) => print(error),
    );
  }

  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mRecorderIsInited = false;
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _mRecordingDataSubscription;

  bool audioDetected = false;

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder!.openRecorder();
    await _mPlayer!.openPlayer();

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

  @override
  void initState() {
    super.initState();
    connect();
    _openRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    release();
    super.dispose();
  }

  Future<void> release() async {
    await stopPlayer();
    await _mPlayer!.closePlayer();
    _mPlayer = null;

    await stopRecorder();
    await _mRecorder!.closeRecorder();
    _mRecorder = null;
  }

  Future<void>? stopRecorder() async {
    await _mRecorder!.stopRecorder();
    if (_recorderSubscription != null) {
      await _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
    audioDetected = false;
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
    _mRecordingDataSubscription = null;
    }
    return null;
  }

  Future<void>? stopPlayer() {
    if (_mPlayer != null) {
      return _mPlayer!.stopPlayer();
    }
    return null;
  }

  Future<void> record() async {
    connect();
    await _mPlayer!.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tPSampleRate,
    );

    var recordingDataController = StreamController<Food>();
    //_mRecorder!.setSubscriptionDuration(const Duration(milliseconds: 100));
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            if (buffer.data != null) {
              socket!.sink.add(buffer.data!);
            }
          }
        });
    var audioListener = StreamController<Food>();
    _recorderSubscription = _mRecorder!.onProgress!.listen((e) {
      if (e.decibels! > 20 && !audioDetected) {
        setState(() => audioDetected = true);
      } else if (e.decibels! < 20 && audioDetected) {
        setState(() => audioDetected = false);
      }
    });

    await _mRecorder!.startRecorder(
      codec: Codec.pcm16,
      toStream: recordingDataController.sink,
      sampleRate: tRSampleRate,
      numChannels: 1,
    );
    setState(() {});
  }

  Future<void> stop() async {
    disconnect();
    if (_mRecorder != null) {
      await _mRecorder!.stopRecorder();
    }
    if (_mPlayer != null) {
      await _mPlayer!.stopPlayer();
    }
    setState(() {});
  }

  Function()? getRecFn() {
    if (!_mRecorderIsInited) {
      audioDetected = false;
      return null;
    }
    return _mRecorder!.isRecording ? stop : record;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: audioDetected ? Colors.green : white,
                  shape: BoxShape.circle,
                ),
                child: OutlinedButton(
                  onPressed: getRecFn(),
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
                  _mRecorder!.isRecording ? 'Stop' : 'Record',
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
