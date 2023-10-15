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
  bool _createToggle = false;
  late List<DateTime> tempList;
  late int currentMonth;
  late int currentDay;
  Future<bool>? done;
  List<Group> groups = [];
  double totalHeight = 60;

  @override
  void initState() {
    tempList = dateList();
    currentMonth = DateTime.now().month;
    currentDay = DateTime.now().day;
    done = ParseGroups();
    super.initState();
  }

  List<DateTime> dateList() {
    List<DateTime> toRet = [];
    DateTime end = widget.filter.end.add(const Duration(days: 1));
    for (DateTime start = widget.filter.start; start != end; start = start.add(const Duration(minutes: 20))) {
      toRet.add(start);
    }
    return toRet;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Text(
                  'I would like to...',
                  style: defaultTextStyle,
                ),
                TextButton(
                  onPressed: () {
                    if (totalHeight == 60) {
                      totalHeight = 120;
                    } else {
                      totalHeight = 60;
                    }
                    setState(() => _createToggle = !_createToggle);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 75,
                        padding: const EdgeInsets.all(5),
                        color: _createToggle ? black : mainSchemeColor,
                        child: Text(
                          'Create',
                          style: TextStyle(
                            color: _createToggle ? white : black,
                            fontSize: infoFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 75,
                        padding: const EdgeInsets.all(5),
                        color: _createToggle ? mainSchemeColor : black,
                        child: Text(
                          'Join',
                          style: TextStyle(
                            color: _createToggle ? black : white,
                            fontSize: infoFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'a group.',
                  style: defaultTextStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 98 - AppBar().preferredSize.height - navBarHeight,
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
                          int groupsList = 0;
                          return ListView.builder(
                            addAutomaticKeepAlives: true,
                            itemCount: tempList.length,
                            itemBuilder: (context, index) {
                              while (groupsList < groups.length && groupsList >= 0 && tempList[index].isAfter(groups[groupsList].date!)) {
                                groupsList++;
                              }
                              if (tempList[index].day != currentDay) {
                                currentDay = tempList[index].day;
                                if (tempList[index].month != currentMonth) {
                                  currentMonth = tempList[index].month;
                                  return Column(
                                    children: <Widget>[
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
                                      const Divider(
                                        height: 5,
                                        thickness: 1,
                                        color: black,
                                      ),
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
                                      const Divider(
                                        height: 5,
                                        thickness: 1,
                                        color: black,
                                      ),
                                      groupsList < groups.length && groupsList >= 0 && (tempList[index] == groups[groupsList].date || (tempList[index].add(const Duration(minutes: 20))).isAfter(groups[groupsList].date!)) ?
                                      GroupCard(group: groups[groupsList++], height: totalHeight) : GroupCard(date: tempList[index], height: totalHeight),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: <Widget>[
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
                                      const Divider(
                                        height: 5,
                                        thickness: 1,
                                        color: black,
                                      ),
                                      groupsList < groups.length && groupsList >= 0 && (tempList[index] == groups[groupsList].date || (tempList[index].add(const Duration(minutes: 20))).isAfter(groups[groupsList].date!))
                              ? GroupCard(group: groups[groupsList++], height: totalHeight) : GroupCard(date: tempList[index], height: totalHeight),
                                    ],
                                  );
                                }
                              }
                              if (groupsList < groups.length && groupsList >= 0 && (tempList[index] == groups[groupsList].date || (tempList[index].add(const Duration(minutes: 20))).isAfter(groups[groupsList].date!))) {
                                return GroupCard(group: groups[groupsList++], height: totalHeight);
                              } else {
                                return GroupCard(date: tempList[index], height: totalHeight);
                              }

                            },
                          );
                      }
                    }
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> ParseGroups() async {
    groups = [];

    DateTime end = widget.filter.end.add(const Duration(days: 1));
    Map<String, dynamic> queryDate = {};

    for (DateTime start = widget.filter.start; start != end; start = start.add(const Duration(days: 1))) {
      queryDate['date'] = DateFormat('yyyy-MM-dd').format(start);

      final res = await GroupsAPI.getSchedule(queryDate);

      if (res.statusCode != 200) {
        print(res.statusCode);
        return false;
      }
      print(res.body);

      var data = json.decode(res.body);

      for (var concerts in data['scheduledTimes']) {
        Group newGroup = Group.fromJson(concerts);
        if (groups.isNotEmpty) {
          int place = 0;
          for (int i = 0; i < groups.length; i++) {
            if (newGroup.date!.isAfter(groups[i].date!)) {
              break;
            }
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
