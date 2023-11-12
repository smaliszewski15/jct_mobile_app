import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../APIfunctions/concertAPI.dart';
import '../models/group.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class GroupCard extends StatefulWidget {
  late final DateTime? date;
  late int? id;
  final buttonNotifier = ValueNotifier<double>(25);
  late double height;
  bool clickable;
  final ValueNotifier added;

  GroupCard({this.id, this.height = 60, this.date, required this.clickable, required this.added}) {
    buttonNotifier.value = height;
  }

  void changeHeight(double newHeight) => height = newHeight;

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard>
    with AutomaticKeepAliveClientMixin {
  Future<bool>? done;
  Group? group;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<double>(
      valueListenable: widget.buttonNotifier,
      builder: (_, value, __) {
        return widget.id != null
            ? reserved(widget.id!)
            : notReserved();
      },
    );
  }

  Widget reserved(int id) {
    done = getGroup();
    return FutureBuilder(
        future: done,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Container(
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
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                print('hereError');
                return Text('Error: $snapshot.error}',
                  style: smallTextStyle,
                );
              }

              return Container(
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
                        arguments: id);
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
                            group!.date != null
                                ? DateFormat('jm').format(group!.date!)
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
                                  group!.title,
                                  style: whiteDefaultTextStyle,
                                ),
                                Text(
                                  group!.maestro,
                                  style: smallTextStyle.copyWith(color: white),
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
                                  group!.title,
                                  style: defaultTextStyle,
                                ),
                                Text(
                                  group!.maestro,
                                  style: smallTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
          }
        }
      );
  }

  Widget notReserved() {
    return TextButton(
      onPressed: widget.clickable
          ? () {
        Navigator.pushNamed(context, '/group/add',
            arguments: widget.date!).then((entry) {
          print(entry);
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
  }

  Future<bool> getGroup() async {
    if (widget.id == null) {
      return false;
    }

    Map<String, dynamic> query = {
      'id': '${widget.id}',
    };

    final res = await ConcertsAPI.getSongData(query);


    if (res.statusCode != 200) {
      print(res.body);
      return false;
    }

    var data = json.decode(res.body);
    if (!data.containsKey('group')) {
      return false;
    }

    group = Group.fromScheduleJson(data['group']);

    return true;
  }

  @override
  bool get wantKeepAlive => true;
}
