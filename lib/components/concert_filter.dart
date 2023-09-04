import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class TagFilterDrawer extends StatefulWidget {

  @override
  _TagFilterDrawerState createState() => _TagFilterDrawerState();
}

class _TagFilterDrawerState extends State<TagFilterDrawer> {

  @override
  void initState() {
    super.initState();
  }

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
              'Filter by concert tags:',
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
        ],
      ),
    );
  }
}
