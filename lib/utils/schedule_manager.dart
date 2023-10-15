import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';
import '../utils/globals.dart';

class ScheduleManager {

  late DateTime start;
  late DateTime end;
  late DateTime toChangeStart;
  late DateTime toChangeEnd;
  final changedNotifier = ValueNotifier<bool>(false);

  ScheduleManager() {
    _init();
  }

  _init() async {
    setStart();
    end = start.add(const Duration(days: 5));
    toChangeStart = start;
    toChangeEnd = end;
  }

  void refreshFilter() {
    _init();
  }

  void setStart() {
    DateTime now = DateTime.now();
    start = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    if (start.minute % 20 != 0) {
      start = start.add(Duration(minutes: 20 - (start.minute % 20)));
    }
  }

  bool isStartChanged() {
    if (toChangeStart != start) {
      return true;
    }
    return false;
  }

  bool isEndChanged() {
    if (toChangeEnd != end) {
      return true;
    }
    return false;
  }

  bool isChanged() {
    if (isStartChanged() || isEndChanged()) {
      return true;
    }
    return false;
  }

  Future<void> selectStartDate(BuildContext context) async {
    var currentDate = DateTime.now();
    var furthestDate = DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: toChangeStart,
        firstDate: currentDate,
        lastDate: furthestDate,
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: mainSchemeColor,
                  onPrimary: black,
                  surface: black,
                  onSurface: textColor,
                ),
                dialogBackgroundColor: backgroundColor,
              ),
              child: child as Widget);
        });

    if (newSelectedDate != null) {
      toChangeStart = newSelectedDate;
    }

    if (toChangeStart.isAfter(end)) {
      toChangeEnd = toChangeStart;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    var currentDate = DateTime.now();
    var furthestDate = DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: toChangeEnd,
        firstDate: toChangeStart,
        lastDate: furthestDate,
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: mainSchemeColor,
                  onPrimary: black,
                  surface: black,
                  onSurface: textColor,
                ),
                dialogBackgroundColor: backgroundColor,
              ),
              child: child as Widget);
        });

    if (newSelectedDate != null) {
      toChangeEnd = newSelectedDate;
    }
  }

  void updateDates() {
    if (isStartChanged()) {
      start = toChangeStart;
    }
    if (isEndChanged()) {
      end = toChangeEnd;
    }
  }

  void doUpdate() {
    updateDates();
    changedNotifier.value = true;
  }

  void finUpdate() {
    changedNotifier.value = false;
  }

  void noChange() {
    toChangeStart = start;
    toChangeEnd = end;
  }
}