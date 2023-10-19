import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/group.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class GroupCard extends StatefulWidget {
  late final Group? group;
  late double height;
  late final DateTime? date;
  final buttonNotifier = ValueNotifier<double>(25);
  bool clickable = false;

  GroupCard({this.group, this.height = 60, this.date, this.clickable = false}) {
    buttonNotifier.value = height;
  }

  void clickState() => clickable = !clickable;

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
                margin: const EdgeInsets.all(5),
                color: !widget.clickable ? accentColor : mainSchemeColor,
                child:  TextButton(
                  onPressed: widget.clickable ? () {
                    Navigator.pushNamed(
                        context, '/group/group',
                        arguments: widget.group!);
                  } : null,
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
                              color: !widget.clickable ? textColor : black),
                        ),
                        const Spacer(),
                        if (!widget.clickable)
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
                                widget.group!.maestro,
                                style: TextStyle(
                                  fontSize: smallFontSize,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        const Spacer(),
                        Text(
                          '${widget.group!.members!.length}/4',
                          style: TextStyle(
                              fontSize: infoFontSize,
                              color: widget.height == 60 ? textColor : black),
                        ),
                      ],
                    ),
                    if (widget.clickable)
                      Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.group!.title,
                                style: const TextStyle(
                                  fontSize: infoFontSize,
                                  color: black,
                                ),
                              ),
                              Text(
                                widget.group!.maestro,
                                style: const TextStyle(
                                  fontSize: smallFontSize,
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: widget.group!.members!
                                .map((entry) => Text(
                                      entry,
                                      style: const TextStyle(
                                        fontSize: smallFontSize,
                                        color: black,
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
            : TextButton(
            onPressed: widget.clickable ? () {
          Navigator.pushNamed(
                context, '/group/add',
                arguments:
                    widget.date!);
        } : null,
        child: Container(
                width: double.infinity,
                height: 60,
                color: widget.clickable ? mainSchemeColor : accentColor,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      DateFormat('jm').format(widget.date!),
                      style: TextStyle(
                        fontSize: infoFontSize,
                        color: widget.clickable ? black : textColor,
                      ),
                    ),
                ),
              ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
