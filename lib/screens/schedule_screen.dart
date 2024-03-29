import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../APIfunctions/groupsAPI.dart';
import '../components/group_card.dart';
import '../managers/schedule_manager.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../models/group.dart';

class ScheduleScreen extends StatefulWidget {
  late ScheduleManager filter;

  ScheduleScreen(this.filter);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _reserveToggle = false;
  int currentMonth = DateTime.now().month;
  int currentDay = DateTime.now().day;
  Future<bool>? done;
  List<Group> groups = [];
  double totalHeight = 100;
  bool reserving = false;
  bool browsing = true;
  Timer? refresh;

  @override
  void initState() {
    widget.filter.refreshFilter();
    widget.filter.doUpdate();
    DateTime now = DateTime.now();
    int minutes = 20 - (now.minute % 20);
    refresh = Timer.periodic(Duration(minutes: minutes), (Timer t) {
      refresh!.cancel();
      setState(() {
        refresh = Timer.periodic(const Duration(minutes: 20), (Timer t) {
          setState(() {});
        });
      });
    });
    done = ParseGroups();
    super.initState();
  }

  @override
  void dispose() {
    refresh!.cancel();
    super.dispose();
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
          Container(
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
            ),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  onPressed: !_reserveToggle
                      ? () {
                    totalHeight = 60;
                    reserving = true;
                    browsing = false;
                    setState(() => _reserveToggle = true);
                  }
                      : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: 100,
                    height: toggleHeight,
                    decoration: BoxDecoration(
                      color: _reserveToggle ? mainSchemeColor : null,
                      borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Reserve',
                        style: defaultTextStyle.copyWith(
                          color: _reserveToggle ? textColor : whiteTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _reserveToggle
                      ? () {
                    totalHeight = 100;
                    reserving = false;
                    browsing = true;
                    setState(() => _reserveToggle = false);
                  }
                      : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: 100,
                    height: toggleHeight,
                    decoration: BoxDecoration(
                      color: _reserveToggle ? null : mainSchemeColor,
                      borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Browse',
                        style: defaultTextStyle.copyWith(
                          color: _reserveToggle ? whiteTextColor : textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

                            return CustomScrollView(
                              slivers: scheduledDays(),
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

    Map<String, dynamic> queries = {};

    DateTime fromDateTime = widget.filter.start.toUtc();
    DateTime toDateTime = widget.filter.end.toUtc();
    String fromDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(fromDateTime);
    String toDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(toDateTime);
    print("From Date: $fromDate, To Date: $toDate");

    queries['fromDateTime'] = fromDate;
    queries['toDateTime'] = toDate;

    final res = await GroupsAPI.getSchedule(queries);

    if (res.statusCode != 200) {
      print(res.statusCode);
      return false;
    }
    print(res.body);

    var data = json.decode(res.body);

    for (var concerts in data['scheduledGroups']) {
      Group newGroup = Group.fromDateConcert(concerts);
      if (groups.isNotEmpty) {
        int place = 0;
        while (place < groups.length && newGroup.date!.isAfter(groups[place].date!)) {
          place++;
        }
        if (place == groups.length) {
          groups.add(newGroup);
        } else {
          groups.insert(place, newGroup);
        }
      } else {
        groups.add(newGroup);
      }
    }
    print(groups);
    return true;
  }

  List<Widget> scheduledDays() {
    List<Widget> toRet = [];
    DateTime day = widget.filter.start;
    while (!day.isAfter(widget.filter.end)) {
      toRet.add(Section(
        currentMonth: day.month,
        currentDay: day.day,
        groups: groups,
        reserving: reserving,
        browsing: browsing,
        totalHeight: totalHeight,
        changed: widget.filter.changedNotifier
      ));
      day = day.add(const Duration(days: 1));
    }
    return toRet;
  }
}

class Section extends StatelessWidget {
  final int currentMonth;
  final int currentDay;
  final List<Group> groups;
  late final List<DateTime> tempList;
  final bool reserving;
  final bool browsing;
  final double totalHeight;
  final changed;

  Section(
      {required this.currentMonth,
      required this.currentDay,
      required this.groups,
      required this.reserving,
      required this.browsing,
      required this.totalHeight,
      required this.changed}) {
    tempList = dateList();
  }

  List<DateTime> dateList() {
    DateTime date;
    DateTime now = DateTime.now();
    if (currentDay == now.day) {
      if (now.minute % 20 != 0) {
        now = now.subtract(Duration(minutes: now.minute % 20));
      }
      date = DateTime(now.year , currentMonth, currentDay, now.hour, now.minute);
    } else {
      date = DateTime(now.year, currentMonth, currentDay);
    }

    List<DateTime> toRet = [];
    int hoursUntilEndOfDay = 23 - date.hour;
    int minutesUntilEndOfDay = 60 - date.minute;
    DateTime end = date.add(Duration(hours: hoursUntilEndOfDay, minutes: minutesUntilEndOfDay));
    for (DateTime start = date;
        start != end;
        start = start.add(const Duration(minutes: 20))) {
      toRet.add(start);
    }
    return toRet;
  }

  @override
  Widget build(BuildContext context) {
    int groupList = 0;
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        SliverPinnedHeader(
            child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: double.infinity,
            color: backgroundColor,
            child: Text(
              DateFormat('MMMM dd')
                  .format(DateTime(0, currentMonth, currentDay)),
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
        ])),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            while (groupList < groups.length && groups[groupList].date!.isBefore(tempList[index])) {
              groupList++;
            }
            if (groupList < groups.length &&
                groupList >= 0 &&
                tempList[index] == groups[groupList].date) {
              return GroupCard(
                id: groups[groupList++].groupID,
                date: tempList[index],
                height: totalHeight,
                clickable: browsing,
                added: changed,
              );
            } else {
              return GroupCard(
                date: tempList[index],
                height: totalHeight,
                clickable: reserving,
                added: changed,
              );
            }
          },
          childCount: tempList.length,
        ))
      ],
    );
  }
}
