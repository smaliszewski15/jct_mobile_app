import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:john_cage_tribute/components/concert_tags_manager.dart';
import '../APIfunctions/concertAPI.dart';
import '../utils/concert.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class ConcertsScreen extends StatefulWidget {
  late TagsUpdater tags;

  ConcertsScreen(this.tags);

  @override
  _ConcertsState createState() => _ConcertsState();
}

class _ConcertsState extends State<ConcertsScreen> {
  @override
  void initState() {
    super.initState();
    done = getConcertList('');
    searchFocus = FocusNode();
    searchFocus.addListener(() => searchLostFocus());
  }

  List<Concert> searchResults = [];
  String oldQuery = '';
  final _search = TextEditingController();
  Future<bool>? done;
  late FocusNode searchFocus;

  void searchLostFocus() {
    if (!searchFocus.hasFocus && _search.value.text != oldQuery) {
      done = getConcertList(_search.value.text);
      setState(() {});
    }
  }

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
                      focusNode: searchFocus,
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
                      onEditingComplete: () {
                        String query = _search.value.text;
                        if (oldQuery.isEmpty || oldQuery != query) {
                          oldQuery = query;
                          done = getConcertList(query);
                          //getConcertList();
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
            ValueListenableBuilder<bool>(
              valueListenable: widget.tags.changedNotifier,
              builder: (_, value, __) {
                if (value) {
                  done = getConcertList(_search.value.text);
                  widget.tags.finUpdate();
                }
                return FutureBuilder(
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
                            bool selected = false;
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              color: accentColor,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() => selected = true);
                                  Navigator.restorablePushNamed(context, '/concerts/concert', arguments: searchResults[index].id);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
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
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          searchResults[index].maestro,
                                          style: TextStyle(
                                            fontSize: infoFontSize,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.left,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getConcertList(String searchQuery) async {
    Map<String,dynamic> queries = {};

    if (searchQuery.isNotEmpty) {
      queries['query'] = searchQuery;
    }


    if (widget.tags.filteredTags.isNotEmpty) {
      int count = 1;
      for (var tag in widget.tags.filteredTags) {
        queries['tag$count'] = '${tag.tagID}';
        count++;
      }
    }

    final res = await ConcertsAPI.searchSongs(queries);

    if (res.statusCode != 200) {
      return false;
    }

    searchResults = [];

    var data = json.decode(res.body);
    if (!data.containsKey('searchResults')) {
      return false;
    }

    for (var map in data['searchResults']) {
      if (map.containsKey('title') && map.containsKey('id') && map.containsKey('maestro')) {
        searchResults.add(Concert(title: map['title'], id: map['id'], maestro: map['maestro']));
      }
    }
    return true;
  }

/*Future<bool> getConcertList() async {
    searchResults = [];
    var data = ConcertsAPI.searchSongs;
    for (var map in data['searchResults']) {
      if (map.containsKey('title') && map.containsKey('id') && map.containsKey('maestro')) {
        searchResults.add(Concert(title: map['title'], id: map['id'], maestro: map['maestro']));
      }
    }

    return true;
  }*/
}
