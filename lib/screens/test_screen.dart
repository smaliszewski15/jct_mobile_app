import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../APIFunctions/api_globals.dart';
//import '../components/socket_listener.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

const int tSampleRate = 41000;

class TestScreen extends StatefulWidget {

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver{
  final buttonNotifier = ValueNotifier<bool>(false);
  late WebSocketChannel socket;

  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;
  String? _mPath;
  StreamSubscription? _mRecordingDataSubscription;
  StreamSubscription? _recorderSubscription;

  bool audioDetected = false;

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder!.openRecorder();

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

    setState(() {
      _mRecorderIsInited = true;
    });
  }

  @override
  void initState() {
    super.initState();
    connect();
    _openRecorder();
  }

  @override
  void dispose() {

    stopRecorder();
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  void disconnect() {
    socket.sink.add('disconnect');
    socket.sink.close();
    buttonNotifier.value = false;
  }

  void connect() {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080'));
    socket.stream.listen(
          (data) {
        print(data);
        buttonNotifier.value = true;
      },
      onError: (error) => print(error),
    );
  }

  Future<void> record() async {
    assert(_mRecorderIsInited);

    var recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            socket.sink.add(buffer.data!);
          }
        });
    _mRecorder!.setSubscriptionDuration(const Duration(milliseconds: 100));
    _recorderSubscription = _mRecorder!.onProgress!.listen((e) {
      if (e.decibels! > 20 && !audioDetected) {
        setState(() => audioDetected = true);
      } else if (e.decibels! < 20 && audioDetected) {
        setState(() => audioDetected = false);
      }
    });
    await _mRecorder!.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
    setState(() {});
  }

  Future<void> stopRecorder() async {
    await _mRecorder!.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
    if (_recorderSubscription != null) {
      await _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  Function()? getRecorderFn() {
    if (!_mRecorderIsInited) {
      return null;
    }
    return _mRecorder!.isStopped
        ? record
        : () {
      stopRecorder().then((value) => setState(() {}));
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

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
                child: TextButton(
                  onPressed: getRecorderFn(),
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
