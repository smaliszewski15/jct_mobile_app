import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../APIfunctions/concertAPI.dart';
import '../models/concert.dart';
import '../utils/concert_player.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class ConcertPage extends StatefulWidget {
  late final int id;

  ConcertPage(this.id);

  @override
  _ConcertPageState createState() => _ConcertPageState();
}

class _ConcertPageState extends State<ConcertPage> {
  late final ConcertPlayer _pageManager;
  Concert concert = Concert();
  Future<bool>? done;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _pageManager = ConcertPlayer(widget.id);
    done = getConcert(widget.id);
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus.fromInt(data[1]);
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _pageManager.dispose();
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    if (IsolateNameServer.lookupPortByName('downloader_send_port') == null) {
      return;
    }
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_pageManager.buttonNotifier.value == ButtonState.playing) {
            _pageManager.pause;
            return true;
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
                }),
            backgroundColor: mainSchemeColor,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: backgroundColor,
          body: FutureBuilder(
            future: done,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    print('hereError');
                    return Text('Error: $snapshot.error}',
                        style: smallTextStyle,
                    );
                  }
                  if (concert.id == -1) {
                    print('concert id is -1');
                    return Text("Error: Concert could not be retrieved");
                  }
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              concert.title,
                              style: titleTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            'Description: ',
                            style: headingTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: white,
                            ),
                            color: accentColor,
                          ),
                          child: Text(
                            concert.description,
                            style: whiteDefaultTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            'Group Leader: ',
                            style: headingTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: white,
                            ),
                            color: accentColor,
                          ),
                          child: Text(
                            concert.maestro,
                            style: whiteDefaultTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            'Recording Date: ',
                            style: headingTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: white,
                            ),
                            color: accentColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  concert.date != null
                                      ? DateFormat('yyyy-MM-dd HH:mm')
                                      .format(concert.date!)
                                      : 'No Date',
                                  style: whiteDefaultTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            'Performers: ',
                            style: headingTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Column(
                            children: concert.performers.map((entry) {
                              return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: white,
                                    ),
                                    color: accentColor,
                                  ),
                                  child: Text(
                                    entry,
                                    style: whiteDefaultTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            'Tags: ',
                            style: headingTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: white,
                            ),
                            color: accentColor,
                          ),
                          child: Text(
                            concert.tags.split('`').join(', '),
                            style: whiteDefaultTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ValueListenableBuilder<ButtonState>(
                            valueListenable: _pageManager.buttonNotifier,
                            builder: (_, value, __) {
                              switch (value) {
                                case ButtonState.loading:
                                  return const SizedBox(
                                    width: 250,
                                    height: 250,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                case ButtonState.paused:
                                  return IconButton(
                                    icon: Icon(
                                      Icons.play_circle_filled,
                                      color: mainSchemeColor,
                                    ),
                                    iconSize: 250,
                                    onPressed: _pageManager.play,
                                  );
                                case ButtonState.playing:
                                  return IconButton(
                                    icon: Icon(
                                      Icons.pause,
                                      color: mainSchemeColor,
                                    ),
                                    iconSize: 250,
                                    onPressed: _pageManager.pause,
                                  );
                              }
                            }),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          child: ValueListenableBuilder<ProgressBarState>(
                            valueListenable: _pageManager.progressNotifier,
                            builder: (_, value, __) {
                              return ProgressBar(
                                progress: value.current,
                                buffered: value.buffered,
                                total: value.total,
                                onSeek: _pageManager.seek,
                              );
                            },
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: mainSchemeColor,
                              border: Border.all(color: black),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                await download();
                              },
                              child: Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: bigButtonFontSize,
                                  color: buttonTextColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*Center(
                        child: TextButton(
                          onPressed: null,
                          child: Text(
                            'Report',
                            style: TextStyle(
                              fontSize: infoFontSize,
                              color: invalidColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  );
              }
            },
          ),
        ));
  }

  Future<bool> getConcert(int ID) async {
    Map<String, dynamic> query = {
      'id': '$ID',
    };

    final res = await ConcertsAPI.getSongData(query);


    if (res.statusCode != 200) {
      print(res.body);
      return false;
    }

    var data = json.decode(res.body);
    if (!data.containsKey('group')) {
      return false;
    }

    concert = Concert.songFromJson(data['group']);

    return true;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        return true;
      }

      final result = await Permission.storage.request();
      if (result != PermissionStatus.granted) {
        return false;
      }
      return true;
    }

    throw StateError('unknown platform');
  }

  Future<void> download() async {
    bool hasPerms = await _checkPermission();
    if (!hasPerms) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    if (!FlutterDownloader.initialized) {
      await FlutterDownloader.initialize(
        debug: false,
        ignoreSsl: true,
      );
    }
    var filePathWav = '/storage/emulated/0/Download/${concert.title}.wav';
    var filePathMP3 = '/storage/emulated/0/Download/${concert.title}.MP3';
    bool existsWav = await File(filePathWav).exists();
    bool existsMP3 = await File(filePathMP3).exists();
    if (existsWav || existsMP3) {
      var replace = await showDialog(context: context, builder: (context) {
        return AlertDialog(
          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          elevation: 15,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Don\'t Replace',
                style: invalidTextStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Replace',
                style: invalidTextStyle,
              ),
            ),
          ],
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                  child: Text(
                      'This file already exists. Do you want to replace it?')),
            ],
          ),
        );
      });

      if (replace != true) {
        return;
      }
      if (existsWav) {
        await File(filePathWav).delete();
      } else {
        await File(filePathMP3).delete();
      }
    }

    final taskId = await FlutterDownloader.enqueue(
      url: 'http://johncagetribute.org/api/concerts/downloadConcertFile?id=${concert.id}',//'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: '/storage/emulated/0/Download/',
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );

    await FlutterDownloader.registerCallback(downloadCallback);
  }
}
