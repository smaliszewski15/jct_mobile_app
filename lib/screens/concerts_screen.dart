import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../APIfunctions/concertAPI.dart';
import '../utils/concert.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class ConcertsScreen extends StatefulWidget {
  @override
  _ConcertsState createState() => _ConcertsState();
}

class _ConcertsState extends State<ConcertsScreen> {
  @override
  void initState() {
    super.initState();
    done = getConcertList('');
  }

  List<Concert> searchResults = [];
  String oldQuery = '';
  final _search = TextEditingController();
  Future<bool>? done;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                height: 35,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: searchFieldColor,
                ),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 9,
                      child: TextField(
                        maxLines: 1,
                        controller: _search,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: buttonTextColor,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                          ),
                        ),
                        style: TextStyle(
                          color: buttonTextColor,
                          fontSize: 18,
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (query) {
                          if (oldQuery.isEmpty || oldQuery != query) {
                            oldQuery = query;
                            getConcertList(query);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const Icon(
                      Icons.search,
                      color: black,
                      size: 15,
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: done,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: $snapshot.error}');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: accentColor,
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.restorablePushNamed(context, '/concerts/concert', arguments: searchResults[index].title);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  searchResults[index].title,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ],
          ),
      ),
    );
  }

  Future<bool> getConcertList(String searchQuery) async {
    searchResults = [];

    final res = await Concerts.searchSongs();

    if (res.statusCode != 200) {
      return false;
    }

    var data = json.decode(res.body);
    if (!data.containsKey('searchResults')) {
      return false;
    }

    for (var map in data['searchResults']) {
      if (map.containsKey('Title') && map.containsKey('ID')) {
        searchResults.add(Concert(title: map['Title'], id: map['ID']));
      }
    }
    return true;
  }
}
