/*import 'dart:convert';
import 'dart:io';*/

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<String> list = ['Bananas', 'Oranges', 'Strawberrys', 'Blueberrys', 'Apples'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: gold,
                    border: Border.all(color: black, width: 3),
                  ),
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text(
                      'My Groups',
                      style: TextStyle(
                        fontSize: infoFontSize,
                        color: buttonTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor,
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.restorablePushNamed(context, '/groups/group', arguments: list[index]);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        list[index],
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
}
