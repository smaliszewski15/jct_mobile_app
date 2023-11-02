import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';
import '../utils/globals.dart';

class ConcertSearchManager {

  late DateTime start;
  late DateTime end;
  late DateTime toChangeStart;
  late DateTime toChangeEnd;
  final changedNotifier = ValueNotifier<bool>(false);

  ConcertSearchManager() {
    _init();
  }

  _init() async {
    start = DateTime(1999);
    end = DateTime.now();
    toChangeStart = start;
    toChangeEnd = end;
  }

  void refreshFilter() {
    _init();
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
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: toChangeStart,
        firstDate: DateTime(1999),
        lastDate: DateTime.now(),
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
      DateTime now = DateTime.now();
      if (newSelectedDate.month == now.month && newSelectedDate.day == now.day) {
        newSelectedDate.add(Duration(hours: now.hour, minutes: now.minute));
      }
      toChangeStart = newSelectedDate;
    }

    if (toChangeStart.isAfter(end)) {
      toChangeEnd = toChangeStart;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: toChangeEnd,
        firstDate: toChangeStart,
        lastDate: DateTime.now(),
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