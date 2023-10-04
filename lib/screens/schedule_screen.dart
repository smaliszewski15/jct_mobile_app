import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
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

  @override
  void initState() {
    done = getDateList();
    currentMonth = DateTime.now().month;
    currentDay = DateTime.now().day;
    super.initState();
  }

  Future<bool> getDateList() async {
    tempList = dateList();
    return true;
  }

  List<DateTime> dateList() {
    List<DateTime> toRet = [];
    for (DateTime start = widget.filter.start; start != widget.filter.end; start = start.add(const Duration(minutes: 20))) {
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
                  done = getDateList();
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
                            addAutomaticKeepAlives: true,
                            itemCount: tempList.length,
                            itemBuilder: (context, index) {
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
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        color: accentColor,
                                        child: Text(
                                          DateFormat('jm').format(tempList[index]),
                                          style: defaultTextStyle,
                                        ),
                                      ),
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
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        color: accentColor,
                                        child: Text(
                                          DateFormat('jm').format(tempList[index]),
                                          style: defaultTextStyle,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }

                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                color: accentColor,
                                child: Text(
                                  DateFormat('jm').format(tempList[index]),
                                  style: defaultTextStyle,
                                ),
                              );
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
}
