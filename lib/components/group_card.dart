import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/group.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class GroupCard extends StatefulWidget {
  late Group group;

  GroupCard(this.group);

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> with AutomaticKeepAliveClientMixin {

  @override
  Widget build (BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          vertical: 5),
      padding: const EdgeInsets.symmetric(
          horizontal: 5, vertical: 5),
      color: accentColor,
      child: Text(
        widget.group.scheduledDate != null ? DateFormat('jm').format(widget.group.scheduledDate!) : DateFormat('jm').format(DateTime.now()),
        style: defaultTextStyle,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
