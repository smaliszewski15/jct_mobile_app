import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import '../utils/concert_tags_manager.dart';
import '../APIfunctions/concertAPI.dart';
import '../APIfunctions/groupsAPI.dart';
import '../components/concert_card.dart';
import '../utils/concert.dart';
import '../utils/colors.dart';
import '../utils/group.dart';
import '../utils/globals.dart';
import '../utils/concert_search_manager.dart';

class ConcertsScreen extends StatefulWidget {
  late final ConcertSearchManager filter;

  ConcertsScreen(this.filter);

  @override
  _ConcertsState createState() => _ConcertsState();
}

class _ConcertsState extends State<ConcertsScreen> {
  @override
  void initState() {
    super.initState();
    getNextConcert();
    done = getConcertList('');
    searchFocus.addListener(() => searchLostFocus());
  }

  @override
  void dispose() {
    searchFocus.removeListener(searchLostFocus);
    super.dispose();
  }

  Group upcoming = Group();
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
    double blockHeight = 50;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: blockHeight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          fontSize: infoFontSize,
                        ),
                      ),
                      style: TextStyle(
                        color: buttonTextColor,
                        fontSize: infoFontSize,
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
                    size: smallIconSize,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: mainSchemeColor,
                border: Border.all(color: black, width: 3),
              ),
              child: upcoming.groupID != -1 ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    upcoming.date!.isBefore(DateTime.now()) ? 'Concert Playing Now!' : 'Upcoming Concert',
                    style: TextStyle(
                      fontSize: headingFontSize,
                      color: buttonTextColor,
                    ),
                  ),
                  Text(
                    "Title: ${upcoming.title}",
                    style: TextStyle(
                      fontSize: infoFontSize,
                      color: buttonTextColor,
                    ),
                  ),
                  Text(
                    "Concert Date and Time: ${DateFormat('yyyy-MM-dd HH:mm').format(upcoming.date!)}",
                    style: TextStyle(
                      fontSize: infoFontSize,
                      color: buttonTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Maestro: ${upcoming.maestro}",
                    style: TextStyle(
                      fontSize: infoFontSize,
                      color: buttonTextColor,
                    ),
                  ),
                  Text(
                    "Tags: ${upcoming.tags.split('`').join(', ')}",
                    style: TextStyle(
                      fontSize: infoFontSize,
                      color: buttonTextColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/group/group',
                          arguments: upcoming).then((entry) {
                            getNextConcert();
                      });
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: headingFontSize,
                        color: Color(0xff2483f0),
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    child: const Text(
                      "Check it out ->",
                    ),
                  ),
                ],
              ) : Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                child: Text(
                  'No upcoming concerts at this time. Go schedule one by going to the "Schedule" tab!',
                  style: TextStyle(
                    fontSize: headingFontSize,
                    color: buttonTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: blockHeight,
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
            const Divider(
              height: 5,
              thickness: 1,
              color: black,
            ),
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: widget.filter.changedNotifier,
                builder: (_, value, __) {
                  if (value) {
                    done = getConcertList(_search.value.text);
                    widget.filter.finUpdate();
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
                              return ConcertCard(concert: searchResults[index]);
                            },
                          );
                      }
                    },
                  );
                },
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

    DateTime fromDateTime = widget.filter.start.toUtc();
    DateTime toDateTime = widget.filter.end.toUtc();
    String fromDate = DateFormat("yyyy-MM-ddTHH\:mm\:ss").format(fromDateTime);
    String toDate = DateFormat("yyyy-MM-ddTHH\:mm\:ss").format(toDateTime);
    print("From Date: $fromDate, To Date: $toDate");

    queries['fromDateTime'] = fromDate;
    queries['toDateTime'] = toDate;

    final res = await ConcertsAPI.searchSongs(queries);

    if (res.statusCode != 200) {
      print(res.body);
      return false;
    }
    print(res.body);

    if (searchQuery != oldQuery) {
      page = 0;
    }

    var data = json.decode(res.body);
    if (!data.containsKey('searchResults')) {
      return false;
    }

    if (data['searchResults'].isEmpty) {
      hadMore = false;
      if (page != 0) {
        page--;
      }
      totalPages = page;
      _showSnack(context);
      return true;
    }
    searchResults = [];

    for (var map in data['searchResults']) {
      Concert newConcert = Concert.searchedSong(map);
      searchResults.add(newConcert);
    }
    return true;
  }

  Future<bool> getNextConcert() async {

    final res = await GroupsAPI.getNextConcert();

    if (res.statusCode != 200) {
      print(res.body);
      return false;
    }

    var data = json.decode(res.body);
    if (!data.containsKey('nextConcertGroup')) {
      return false;
    }
    data = data['nextConcertGroup'];

    upcoming = Group.fromNextJson(data);
    setState(() {});
    return true;
  }

  Widget PageCounter() {
    if (page == 0) {
      if (totalPages + 1 == 1) {
        return Text(
          ' 1 ',
          style: defaultTextStyle,
        );
      }
      if (page + 1 == totalPages) {
        return Text(
          ' 1,2 ',
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

  //Old method of retrieving concerts, without API attached
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
