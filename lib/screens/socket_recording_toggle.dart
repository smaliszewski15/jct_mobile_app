import 'dart:async';
import 'dart:typed_data';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../APIFunctions/api_globals.dart';
//import '../components/socket_listener.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

const int tRSampleRate = 32000;
const int tPSampleRate = 32000;
final Uint8List silence = Uint8List.fromList(List.filled(5000,0));

class SocketScreen extends StatefulWidget {

  @override
  _SocketScreenState createState() => _SocketScreenState();
}

class _SocketScreenState extends State<SocketScreen> {
  final buttonNotifier = ValueNotifier<bool>(false);
  late WebSocketChannel? socket;

  void disconnect() {
    if (socket == null) {
      return;
    }
    socket!.sink.add('disconnect');
    socket!.sink.close();
    socket = null;
    buttonNotifier.value = false;
  }

  Future<void> connect() async {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080'));
  }

  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mRecorderIsInited = false;
  StreamSubscription? _audioDetectedSubscription;
  StreamSubscription? _mRecordingDataSubscription;
  StreamSubscription? _playbackSub;
  bool _isListening = false;

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
    disconnect();
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
    if (_audioDetectedSubscription != null) {
      await _audioDetectedSubscription!.cancel();
      _audioDetectedSubscription = null;
    }
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
    if (socket == null) {
      await connect();
    }
    if (_playbackSub != null) {
      _playbackSub!.cancel();
    }

    var recordingDataController = StreamController<Food>();
    _mRecorder!.setSubscriptionDuration(const Duration(milliseconds: 100));
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            if (buffer.data != null) {
              print(buffer.data);
              socket!.sink.add(buffer.data!);
            }
          }
        });

    _audioDetectedSubscription = _mRecorder!.onProgress!.listen((e) {
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

    await _mPlayer!.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tPSampleRate,
    );

    _mPlayer!.foodSink!.add(FoodData(silence));

    setState(() {});
  }

  Future<void> stop() async {
    if (_mRecorder != null) {
      await _mRecorder!.stopRecorder();
    }
    if (_mPlayer != null) {
      await _mPlayer!.stopPlayer();
    }
    disconnect();
    setState(() => audioDetected = false);
  }

  Function()? getRecFn() {
    if (!_mRecorderIsInited) {
      audioDetected = false;
      return null;
    }
    return _mRecorder!.isRecording ? stop : listOrRec;
  }

  Function()? listOrRec() {
    return _isListening ? listen : record;
  }

  Future<void> listen() async {
    await stopRecorder();
    await _mPlayer!.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tPSampleRate,
    );
    if (socket == null) {
      await connect();
    }
    _playbackSub = socket!.stream.listen(
          (data) {
        print(data);
        _mPlayer!.foodSink!.add(FoodData(data));
      },
      onError: (error) => print(error),
      onDone: () => stop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        stop();
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
                  _mRecorder!.isRecording ? 'Stop' : 'Connect',
                  style: TextStyle(
                    color: buttonTextColor,
                    fontSize: titleFontSize,
                  )
              ),
              Container(
                  margin: const EdgeInsets.all(15),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _isListening = !_isListening);
                      listOrRec();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 150,
                          padding: const EdgeInsets.all(5),
                          color: _isListening ? black : mainSchemeColor,
                          child: Text(
                            'Record',
                            style: TextStyle(
                              color: _isListening ? white : black,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.all(5),
                          color: _isListening ? mainSchemeColor : black,
                          child: Text(
                            'Listen',
                            style: TextStyle(
                              color: _isListening ? black : white,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
