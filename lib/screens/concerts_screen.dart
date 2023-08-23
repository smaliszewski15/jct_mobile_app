/*import 'dart:convert';
import 'dart:io';*/

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import 'individual_concert.dart';

class ConcertsScreen extends StatefulWidget {
  @override
  _ConcertsState createState() => _ConcertsState();
}

class _ConcertsState extends State<ConcertsScreen> {
  @override
  void initState() {
    super.initState();
    searchResults = searchList;
  }

  List<String> searchList = ['Banana', 'Orange', 'Strawberry', 'Blueberry', 'Apple'];
  List<String> searchResults = [];
  String oldQuery = '';
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        buildList();
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
          ListView.builder(
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
                        Navigator.restorablePushNamed(context, '/concerts/concert', arguments: searchResults[index]);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          searchResults[index],
                          style: TextStyle(
                            fontSize: 24,
                            color: textColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  );
              }),
        ],
      ),
    );
  }

  void buildList() {
    searchResults = [];
    for (int i = 0; i < searchList.length; i++) {
      if (searchList[i].toLowerCase().contains(oldQuery)) {
        searchResults.add(searchList[i]);
      }
    }
  }
}
