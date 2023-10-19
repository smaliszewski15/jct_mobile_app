import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../APIfunctions/concertAPI.dart';
import '../utils/concert.dart';
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

  @override
  void initState() {
    super.initState();
    _pageManager = ConcertPlayer(widget.id);
    done = getConcert(widget.id);
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
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
                icon: const Icon(Icons.navigate_before, color: gold),
                iconSize: 35,
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: black,
            automaticallyImplyLeading: false,
          ),
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
                        style: TextStyle(
                          color: black,
                          fontSize: smallFontSize,
                        ));
                  }
                  if (concert.id == -1) {
                    print('here');
                    return Text("Error: Concert could not be retrieved");
                  }
                  return SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: backgroundColor,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 40),
                              child: Text(
                                concert.title,
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Group Leader: ',
                                  style: TextStyle(
                                    fontSize: headingFontSize,
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  concert.maestro,
                                  style: TextStyle(
                                    fontSize: infoFontSize,
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              'Recording Date: ',
                              style: TextStyle(
                                fontSize: headingFontSize,
                                color: textColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    concert.date != '' ? concert.date : 'No Date',
                                    style: TextStyle(
                                      fontSize: infoFontSize,
                                      color: textColor,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              'Performers: ',
                              style: TextStyle(
                                fontSize: headingFontSize,
                                color: textColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    concert.performers.toString(),
                                    style: TextStyle(
                                      fontSize: infoFontSize,
                                      color: textColor,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              'Tags: ',
                              style: TextStyle(
                                fontSize: headingFontSize,
                                color: textColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    concert.tags.toString(),
                                    style: TextStyle(
                                      fontSize: infoFontSize,
                                      color: textColor,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ValueListenableBuilder<ButtonState>(
                              valueListenable: _pageManager.buttonNotifier,
                              builder: (_, value, __) {
                                switch (value) {
                                  case ButtonState.loading:
                                    return Container(
                                      margin: const EdgeInsets.all(8),
                                      width: 250,
                                      height: 250,
                                      child: const CircularProgressIndicator(),
                                    );
                                  case ButtonState.paused:
                                    return IconButton(
                                      icon:
                                          const Icon(Icons.play_circle_filled),
                                      iconSize: 250,
                                      onPressed: _pageManager.play,
                                    );
                                  case ButtonState.playing:
                                    return IconButton(
                                      icon: const Icon(Icons.pause),
                                      iconSize: 250,
                                      onPressed: _pageManager.pause,
                                    );
                                }
                              }),
                          Container(
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
                          const Spacer(),
                          /*Center(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: gold,
                                border: Border.all(color: black),
                              ),
                              child: OutlinedButton(
                                onPressed: null,
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
                          Center(
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
                      ),
                    ),
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
      return false;
    }

    var data = json.decode(res.body);
    if (!data.containsKey('group')) {
      return false;
    }

    concert = Concert.songFromJson(data['group']);

    return true;
  }

  /*Concert getConcert(int ID) {
    return Concert.songFromJson(ConcertsAPI.getSong);
  }*/
}
