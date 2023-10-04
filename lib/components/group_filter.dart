import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/schedule_manager.dart';

class FilterDrawer extends StatefulWidget {
  late ScheduleManager filter;

  FilterDrawer(this.filter);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {

  @override
  void initState() {
    super.initState();
    _startDateCon.text = DateFormat('E, MMM dd, yyyy').format(widget.filter.toChangeStart);
    _endDateCon.text = DateFormat('E, MMM dd, yyyy').format(widget.filter.toChangeEnd);
  }

  final _startDateCon = TextEditingController();
  final _endDateCon = TextEditingController();

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
                        widget.filter.noChange();
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
                onTap: () async {
                  await widget.filter.selectStartDate(context);
                  if (widget.filter.isStartChanged()) {
                    _startDateCon.text = DateFormat('E, MMM dd, yyyy').format(
                        widget.filter.toChangeStart);
                    setState(() {});
                  }
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
                onTap: () async {
                  await widget.filter.selectEndDate(context);
                  if (widget.filter.isEndChanged()) {
                    _endDateCon.text = DateFormat('E, MMM dd, yyyy').format(widget.filter.toChangeEnd);
                    setState(() {});
                  }
                },
                onChanged: null,
              ),
            ],
        ),
    );
  }
}
