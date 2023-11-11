import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/group.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class GroupCard extends StatefulWidget {
  late final Group? group;
  late double height;
  late final DateTime? date;
  final buttonNotifier = ValueNotifier<double>(25);
  bool clickable;
  final ValueNotifier added;

  GroupCard({this.group, this.height = 60, this.date, required this.clickable, required this.added}) {
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
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(roundedCorners)),
                  color: widget.clickable ? mainSchemeColor : accentColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0,3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: widget.clickable
                      ? () {
                          Navigator.restorablePushNamed(context, '/group/group',
                              arguments: widget.group!.groupID);
                        }
                      : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Column(
                    mainAxisAlignment: !widget.clickable
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: widget.clickable
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.group!.date != null
                                ? DateFormat('jm').format(widget.group!.date!)
                                : DateFormat('jm').format(DateTime.now()),
                            style: defaultTextStyle.copyWith(
                              color: !widget.clickable ? whiteTextColor : textColor,
                            ),
                          ),
                          const Spacer(),
                          if (!widget.clickable)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.group!.title,
                                  style: defaultTextStyle,
                                ),
                                Text(
                                  widget.group!.maestro,
                                  style: smallTextStyle,
                                ),
                              ],
                            ),
                          const Spacer(),
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
                                  style: defaultTextStyle,
                                ),
                                Text(
                                  widget.group!.maestro,
                                  style: smallTextStyle.copyWith(color: black),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                    ],
                  ),
                ),
              )
            : TextButton(
                onPressed: widget.clickable
                    ? () {
                        Navigator.pushNamed(context, '/group/add',
                            arguments: widget.date!).then((entry) {
                              //print(entry);
                              if (entry == true) {
                                widget.added.value = true;
                              }
                        });
                      }
                    : null,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(roundedCorners)),
                    color: widget.clickable ? mainSchemeColor : accentColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0,3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('jm').format(widget.date!),
                      style: defaultTextStyle.copyWith(
                        color: widget.clickable ? black : whiteTextColor,
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
