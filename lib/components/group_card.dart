import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/group.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class GroupCard extends StatefulWidget {
  late Group? group;
  late double height;
  late DateTime? date;
  final buttonNotifier = ValueNotifier<double>(25);

  GroupCard({this.group, this.height = 60, this.date}) {
    buttonNotifier.value = height;
  }

  void changeHeight(double newHeight) => height = newHeight;

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.buttonNotifier,
      builder: (_, value, __) {
        return widget.group != null
            ? Container(
                width: double.infinity,
                height: widget.height,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                color: widget.height == 60 ? accentColor : mainSchemeColor,
                child: TextButton(
                  onPressed: null,
                  style: null,
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.group!.date != null
                                ? DateFormat('jm').format(widget.group!.date!)
                                : DateFormat('jm').format(DateTime.now()),
                            style: TextStyle(
                                fontSize: infoFontSize,
                                color: widget.height == 60 ? textColor : black),
                          ),
                          const Spacer(),
                          if (widget.height == 60)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.group!.title,
                                  style: TextStyle(
                                    fontSize: infoFontSize,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  widget.group!.groupLeader,
                                  style: TextStyle(
                                    fontSize: bioTextSize,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          const Spacer(),
                          Text(
                            '${widget.group!.members.length}/4',
                            style: TextStyle(
                                fontSize: infoFontSize,
                                color: widget.height == 60 ? textColor : black),
                          ),
                        ],
                      ),
                      if (widget.height == 120)
                        Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.group!.title,
                                  style: TextStyle(
                                    fontSize: infoFontSize,
                                    color:
                                        widget.height == 60 ? textColor : black,
                                  ),
                                ),
                                Text(
                                  widget.group!.groupLeader,
                                  style: TextStyle(
                                    fontSize: bioTextSize,
                                    color:
                                        widget.height == 60 ? textColor : black,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: widget.group!.members
                                  .map((entry) => Text(
                                        entry,
                                        style: TextStyle(
                                          fontSize: bioTextSize,
                                          color: widget.height == 60
                                              ? textColor
                                              : black,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                color: widget.height == 60 ? mainSchemeColor : accentColor,
                child: TextButton(
                  onPressed: null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DateFormat('jm').format(widget.date!),
                        style: TextStyle(
                          fontSize: infoFontSize,
                          color: widget.height == 60 ? black : textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
