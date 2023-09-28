import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class ScheduleScreen extends StatefulWidget {

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _createToggle = false;
  late List<DateTime> tempList;
  late int currentMonth;
  late int currentDay;

  @override
  void initState() {
    tempList = dateList();
    currentMonth = DateTime.now().month;
    currentDay = DateTime.now().day;
    super.initState();
  }

  List<DateTime> dateList() {
    List<DateTime> toRet = [];
    DateTime now = DateTime.now();
    if (now.minute % 20 != 0) {
      now = now.add(Duration(minutes: 20 - (now.minute % 20))) ;
      print(now);
    }

    for (; now.day != DateTime.now().day - 1; now = now.add(const Duration(minutes: 20))) {
      toRet.add(now);
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
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              itemCount: tempList.length,
              itemBuilder: (context, index) {
                if (tempList[index].day != currentDay) {
                  currentDay = tempList[index].day;
                  if (tempList[index].month != currentMonth) {
                    currentMonth = tempList[index].month;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              DateFormat('MMMM').format(DateTime(0, currentMonth)),
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
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              DateFormat('dd').format(DateTime(0, 0, currentDay)),
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
                            color: accentColor,
                            child: Text(
                              DateFormat('jm').format(tempList[index]),
                              style: defaultTextStyle,
                            ),
                          ),
                        ],
                      ),
                    );
                  }else {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              DateFormat('dd').format(DateTime(0, 0, currentDay)),
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
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            color: accentColor,
                            child: Text(
                              DateFormat('jm').format(tempList[index]),
                              style: defaultTextStyle,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: accentColor,
                  child: Text(
                    DateFormat('jm').format(tempList[index]),
                    style: defaultTextStyle,
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
