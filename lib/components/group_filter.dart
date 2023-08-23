import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class FilterDrawer extends StatefulWidget {

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {

  @override
  void initState() {
    super.initState();
    _startDateCon.text = DateFormat('E, MMM dd, yyyy - hh:mm').format(_startDate);
    _endDateCon.text = 'None Selected';
  }

  final _startDateCon = TextEditingController();
  final _endDateCon = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(5),
            shrinkWrap: true,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Filter by when you want to record:',
                  style: defaultTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 20,
                      ),
                    )
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: red,
                          fontSize: 20,
                        ),
                      )
                  ),
                ]
              ),
              Text(
                'Start Date',
                style: defaultTextStyle
              ),
              TextField(
                textAlign: TextAlign.center,
                focusNode: AlwaysDisabledFocusNode(),
                controller: _startDateCon,
                style: defaultTextStyle.copyWith(color: black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  counterText: '',
                  filled: true,
                  fillColor: mainSchemeColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: black),
                  ),
                ),
                onTap: () {
                  _selectStartDate(context);
                },
                onChanged: null,
              ),
              Text(
                  'End Date',
                  style: defaultTextStyle
              ),
              TextField(
                textAlign: TextAlign.center,
                focusNode: AlwaysDisabledFocusNode(),
                controller: _endDateCon,
                style: defaultTextStyle.copyWith(color: black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  counterText: '',
                  filled: true,
                  fillColor: mainSchemeColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: black),
                  ),
                ),
                onTap: () {
                  _selectEndDate(context);
                },
                onChanged: null,
              ),
            ],
        ),
    );
  }

  _selectStartDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _startDate != null ? _startDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
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
      _startDate = newSelectedDate;
      _startDateCon.text = DateFormat('E, MMM dd, yyyy - hh:mm').format(newSelectedDate);
    }

    if (_startDate.isAfter(_endDate)) {
      _endDate = _startDate;
      _endDateCon.text = 'None Selected';
    }
    setState(() {});
  }

  _selectEndDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _startDate != null ? _startDate : DateTime.now(),
        firstDate: _startDate != null ? _startDate : DateTime.now(),
        lastDate: DateTime(2030),
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
      _endDate = newSelectedDate;
      _endDateCon.text = DateFormat('E, MMM dd, yyyy - hh:mm').format(newSelectedDate);
    }
    setState(() {});
  }

  _setTime(BuildContext context) async {

  }
}