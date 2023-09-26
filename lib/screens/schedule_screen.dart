import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class ScheduleScreen extends StatefulWidget {

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Container(),
      )
    );
  }
}
