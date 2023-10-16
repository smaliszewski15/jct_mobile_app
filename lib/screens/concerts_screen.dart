import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:john_cage_tribute/utils/concert_tags_manager.dart';
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
    searchFocus.addListener(() => searchLostFocus());
  }

  @override
  void dispose() {
    searchFocus.removeListener(searchLostFocus);
    super.dispose();
  }

  List<Concert> searchResults = [];
  String oldQuery = '';
  final _search = TextEditingController();
  Future<bool>? done;
  FocusNode searchFocus = FocusNode();
  int page = 0;
  int totalPages = 50;
  bool hadMore = true;

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
      child: SingleChildScrollView(
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
                      onSubmitted: (query) {
                        if (oldQuery.isEmpty || oldQuery != query) {
                          print(query);
                          done = getConcertList(query);
                          oldQuery = query;
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
            SizedBox(
              width: double.infinity,
              height: 610,
              child: ValueListenableBuilder<bool>(
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
                            key: ValueKey(page),
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.all(10),
                                color: accentColor,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.restorablePushNamed(
                                        context, '/concerts/concert',
                                        arguments: searchResults[index].id);
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
                                          )),
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
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (page != 0)
                      ElevatedButton(
                        onPressed: (){
                          page--;
                          done = getConcertList(oldQuery);
                          setState(() {});
                        },
                        child: Text(
                          'Prev',
                          style: defaultTextStyle,
                        ),
                      ),
                    PageCounter(),
                    if (hadMore || page != totalPages)
                      ElevatedButton(
                        onPressed: () async {
                          page++;
                          (done = getConcertList(oldQuery)).then((entry) => {
                            setState(() {})
                          });
                        },
                        child: Text(
                          'Next',
                          style: defaultTextStyle,
                        ),
                      ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getConcertList(String searchQuery) async {
    Map<String, dynamic> queries = {};

    if (searchQuery.isNotEmpty) {
      queries['search'] = searchQuery;
    }
    queries['page'] = '$page';

    // if (widget.tags.filteredTags.isNotEmpty) {
    //   int count = 1;
    //   for (var tag in widget.tags.filteredTags) {
    //     queries['tag$count'] = '${tag.tagID}';
    //     count++;
    //   }
    // }

    final res = await ConcertsAPI.searchSongs(queries);

    if (res.statusCode != 200) {
      print(res.body);
      return false;
    }

    if (searchQuery != oldQuery) {
      page = 0;
    }
    searchResults = [];

    var data = json.decode(res.body);
    if (!data.containsKey('searchResults')) {
      return false;
    }

    if (data['searchResults'].isEmpty) {
      hadMore = false;
      page--;
      totalPages = page;
      _showSnack(context);
      return getConcertList(oldQuery);
    }

    for (var map in data['searchResults']) {
      searchResults.add(Concert.searchedSong(map));
    }
    return true;
  }

  Widget PageCounter() {
    if (page == 0) {
      if (totalPages + 1 == 1) {
        return Text(
          ' 1',
          style: defaultTextStyle,
        );
      }
      return Text(
        ' 1,... ',
        style: defaultTextStyle,
      );
    }
    if (page == totalPages) {
      if (totalPages == 1) {
        return Text(
          ' 1,2 ',
          style: defaultTextStyle,
        );
      }
      return Text(
        ' 1,...,${totalPages+1} ',
        style: defaultTextStyle,
      );
    }
    if (page == 1) {
      if (totalPages - page == 1) {
        return Text(
          ' 1,2,3 ',
          style: defaultTextStyle,
        );
      }
      return Text(
        ' 1,2,... ',
        style: defaultTextStyle,
      );
    }
    if (totalPages - page == 1) {
      if (totalPages - page == 1) {
        return Text(
          ' 1,2,3 ',
          style: defaultTextStyle,
        );
      }
      return Text(
        ' 1,...,${page+1},${totalPages+1} ',
        style: defaultTextStyle,
      );
    }
    return Text(
      ' 1,...,${page+1},...,${totalPages+1} ',
      style: defaultTextStyle,
    );
  }

  void _showSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: WillPopScope(
          onWillPop: () async {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            return true;
          },
          child: const Text('No more concerts to view'),
        ),
        duration: Duration(seconds: 3),
      ),
    );
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
