import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../APIfunctions/groupsAPI.dart';
import '../components/group_card.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/group.dart';
import '../utils/schedule_manager.dart';

class ScheduleScreen extends StatefulWidget {
  late ScheduleManager filter;

  ScheduleScreen(this.filter);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _reserveToggle = false;
  late List<DateTime> tempList;
  int currentMonth = DateTime.now().month;
  int currentDay = DateTime.now().day;
  Future<bool>? done;
  List<Group> groups = [];
  double totalHeight = 120;
  bool reserving = false;
  bool browsing = true;

  @override
  void initState() {
    widget.filter.refreshFilter();
    tempList = dateList();
    done = ParseGroups();
    super.initState();
  }

  List<DateTime> dateList() {
    List<DateTime> toRet = [];
    DateTime end = widget.filter.end.add(const Duration(days: 1));
    for (DateTime start = widget.filter.start;
        start != end;
        start = start.add(const Duration(minutes: 20))) {
      toRet.add(start);
    }
    return toRet;
  }

  @override
  Widget build(BuildContext context) {
    double toggleHeight = 50;
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: !_reserveToggle
                    ? () {
                        if (totalHeight != 120) {
                          totalHeight == 120;
                        }
                        reserving = true;
                        browsing = false;
                        setState(() => _reserveToggle = true);
                      }
                    : null,
                child: Container(
                    width: 100,
                    height: toggleHeight,
                    color: _reserveToggle ? mainSchemeColor : black,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                      'Reserve',
                      style: TextStyle(
                        color: _reserveToggle ? black : white,
                        fontSize: infoFontSize,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: _reserveToggle
                    ? () {
                        if (totalHeight != 50) {
                          totalHeight == 50;
                        }
                        reserving = false;
                        browsing = true;
                        setState(() => _reserveToggle = false);
                      }
                    : null,
                child: Container(
                    width: 100,
                    height: toggleHeight,
                    color: _reserveToggle ? black : mainSchemeColor,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                      'Browse',
                      style: TextStyle(
                        color: _reserveToggle ? white : black,
                        fontSize: infoFontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                key: ValueKey(currentDay),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: double.infinity,
                child: Text(
                  DateFormat('MMMM, dd').format(DateTime(0, currentMonth, currentDay)),
                  style: TextStyle(
                    fontSize: 32,
                    color: textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const Divider(
                height: 5,
                thickness: 1,
                color: black,
              ),
            ],
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
                valueListenable: widget.filter.changedNotifier,
                builder: (_, value, __) {
                  if (value) {
                    done = ParseGroups();
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
                            currentMonth = DateTime.now().month;
                            currentDay = DateTime.now().day;
                            int groupsList = 0;
                            return ListView.builder(
                              addAutomaticKeepAlives: true,
                              itemCount: tempList.length,
                              itemBuilder: (context, index) {
                                if (groupsList < groups.length) {
                                  while (groups[groupsList]
                                      .date!
                                      .isBefore(tempList[index])) {
                                    groupsList++;
                                    if (!(groupsList < groups.length)) {
                                      break;
                                    }
                                  }
                                }
                                bool newDay = false;
                                bool newMonth = false;
                                if (tempList[index].month != currentMonth) {
                                  currentMonth = tempList[index].month;
                                  newMonth = true;
                                }
                                if (tempList[index].day != currentDay) {
                                  currentDay = tempList[index].day;
                                  newDay = true;
                                }
                                return Column(
                                  children: <Widget>[
                                    if (newMonth)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        width: double.infinity,
                                        child: Text(
                                          DateFormat('MMMM').format(
                                              DateTime(0, currentMonth)),
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    if (newMonth)
                                      const Divider(
                                        height: 5,
                                        thickness: 1,
                                        color: black,
                                      ),
                                    if (newDay)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        width: double.infinity,
                                        child: Text(
                                          DateFormat('dd').format(
                                              DateTime(0, 0, currentDay)),
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    if (newDay)
                                      const Divider(
                                        height: 5,
                                        thickness: 1,
                                        color: black,
                                      ),
                                    groupsList < groups.length &&
                                            groupsList >= 0 &&
                                            tempList[index] ==
                                                groups[groupsList].date
                                        ? GroupCard(
                                            group: groups[groupsList++],
                                            height: totalHeight,
                                            clickable: browsing,
                                          )
                                        : GroupCard(
                                            date: tempList[index],
                                            height: totalHeight,
                                            clickable: reserving),
                                  ],
                                );
                              },
                            );
                        }
                      });
                }),
          ),
        ],
      ),
    );
  }

  Future<bool> ParseGroups() async {
    groups = [];

    DateTime end = widget.filter.end.add(const Duration(days: 1));
    Map<String, dynamic> queryDate = {};

    for (DateTime start = widget.filter.start;
        start != end;
        start = start.add(const Duration(days: 1))) {
      queryDate['date'] = DateFormat('yyyy-MM-dd').format(start);

      final res = await GroupsAPI.getSchedule(queryDate);

      if (res.statusCode != 200) {
        print(res.statusCode);
        return false;
      }
      print(res.body);
      String date = DateFormat('yyyy-MM-dd').format(start);

      var data = json.decode(res.body);

      for (var concerts in data['scheduledTimes']) {
        //Group newGroup = Group.fromJson(concerts);
        Group newGroup = Group.fromDateConcert(date, concerts);
        if (groups.isNotEmpty) {
          int place = 0;
          for (int i = 0; i < groups.length; i++) {
            if (newGroup.date!.isBefore(groups[i].date!)) {
              break;
            }
            place++;
          }
          groups.insert(place, newGroup);
        } else {
          groups.add(newGroup);
        }
      }
    }
    return true;
  }

  // List<Group> ParseGroups() {
  //   Map<String, dynamic> groupsJSON = GroupsAPI.getGroups;
  //   if (!groupsJSON.containsKey('groupsData')) {
  //     return [];
  //   }
  //   List<Group> toRet = [];
  //
  //   for (var data in groupsJSON['groupsData']) {
  //     Group newGroup = Group.fromJson(data);
  //     if (toRet.isNotEmpty) {
  //       int place = 0;
  //       for (int i = 0; i < toRet.length; i++) {
  //         if (newGroup.date!.isAfter(toRet[i].date!)) {
  //           break;
  //         }
  //       }
  //       toRet.insert(place, newGroup);
  //     } else {
  //       toRet.add(newGroup);
  //     }
  //   }
  //   return toRet;
  // }
}
