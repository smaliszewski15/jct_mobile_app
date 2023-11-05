import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../APIfunctions/groupsAPI.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/group.dart';
import '../utils/user.dart';

class AddGroup extends StatefulWidget {
  late final DateTime? date;

  AddGroup(this.date);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  late List<String> methods;
  late String method;
  Future<bool>? done;

  @override
  void initState() {
    method = 'First';
    done = getMethods();
    super.initState();
  }

  final _title = TextEditingController();
  bool titleUnfilled = false;
  final _tags = TextEditingController();
  bool tagsUnfilled = false;
  final _description = TextEditingController();
  bool descriptionUnfilled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.navigate_before, color: gold),
          iconSize: 35,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: null,
        backgroundColor: black,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Scheduled Date: ',
                      style: defaultTextStyle,
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd hh:mm').format(widget.date!),
                      style: defaultTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Every concert must have a title. Enter yours here:',
                    style: headingTextStyle,
                    textAlign: TextAlign.center,
                  )),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  maxLines: 1,
                  controller: _title,
                  decoration: titleUnfilled
                      ? InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: '',
                          filled: true,
                          fillColor: mainSchemeColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: invalidColor),
                          ),
                        )
                      : InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: '',
                          filled: true,
                          fillColor: mainSchemeColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: black),
                          ),
                        ),
                  style: buttonTitleTextStyle,
                  onChanged: (field) {
                    if (field.isEmpty) {
                      setState(() => titleUnfilled = true);
                      return;
                    } else {
                      setState(() => titleUnfilled = false);
                    }
                  },
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (titleUnfilled)
              SliverToBoxAdapter(
                child: Text(
                  'You must have a title for your concert',
                  style: invalidTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Mixing Method: ',
                  style: headingTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: done,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: $snapshot.error}');
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          color: mainSchemeColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: black),
                        ),
                        child: DropdownButton<String>(
                          value: method,
                          isExpanded: true,
                          dropdownColor: mainSchemeColor,
                          icon: const Icon(Icons.arrow_drop_down, color: black),
                          onChanged: (String? value) {
                            setState(() {
                              method = value!;
                            });
                          },
                          items: methods.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.capitalize(),
                                  style: const TextStyle(
                                    fontSize: smallFontSize,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Enter a description:',
                    style: headingTextStyle,
                    textAlign: TextAlign.center,
                  )),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  maxLines: 3,
                  controller: _description,
                  decoration: descriptionUnfilled
                      ? InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: '',
                          filled: true,
                          fillColor: mainSchemeColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: invalidColor),
                          ),
                        )
                      : InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: '',
                          filled: true,
                          fillColor: mainSchemeColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: black),
                          ),
                        ),
                  style: blackDefaultTextStyle,
                  onChanged: (field) {
                    if (field.isEmpty) {
                      setState(() => titleUnfilled = true);
                      return;
                    } else {
                      setState(() => titleUnfilled = false);
                    }
                  },
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'And lastly, some tags to describe your concert:',
                  style: headingTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  'Enter as a list of comma separated words',
                  style: defaultTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  maxLines: 1,
                  controller: _tags,
                  decoration: tagsUnfilled
                      ? InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: '',
                          filled: true,
                          fillColor: mainSchemeColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: invalidColor),
                          ),
                        )
                      : InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: '',
                          filled: true,
                          fillColor: mainSchemeColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: black),
                          ),
                        ),
                  style: blackDefaultTextStyle,
                  onChanged: (field) {
                    if (field.isEmpty) {
                      setState(() => titleUnfilled = true);
                      return;
                    } else {
                      setState(() => titleUnfilled = false);
                    }
                  },
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                'Finished? Click \'create\' to finalize your concert. The invitation codes will be sent to your email.',
                style: headingTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: gold,
                  border: Border.all(color: black, width: 3),
                ),
                child: TextButton(
                  onPressed: () async {
                    if (_title.value.text.isEmpty) {
                      setState(() => titleUnfilled = true);
                    } else {
                      bool success = await scheduleGroup();
                      if (!success) {
                        print('Something went wrong!');
                      }
                    }
                  },
                  child: Text(
                    'Create',
                    style: bigButtonTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> scheduleGroup() async {
    var logged = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 15,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  'Register',
                  style: invalidTextStyle,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  'Login',
                  style: invalidTextStyle,
                ),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Text(
                    user.logged
                        ? 'You must log in again to be able to schedule a recording.'
                        : 'You must be logged in to be able to schedule a concert',
                  ),
                ),
              ],
            ),
          );
        });

    if (logged != true) {
      return false;
    }

    String date =
        DateFormat('yyyy-MM-dd').format(widget.date!.toUtc()).toString();
    String time = DateFormat('Hms').format(widget.date!.toUtc()).toString();

    List<String> tags = _tags.value.text.split(', ');
    print(tags);

    Map<String, dynamic> package = {
      'concertTitle': _title.value.text,
      'concertTags': tags,
      'concertDescription': _description.value.text,
      'date': date,
      'time': time,
    };

    if (context.mounted) {
      Navigator.pushNamed(context, logged ? '/login' : '/register')
          .then((entry) async {
        if (!user.logged) {
          print('not logged');
          return false;
        }
        package['username'] = user.username;
        package['password'] = user.password;

        final res = await GroupsAPI.schedule(package);

        if (res.statusCode != 200) {
          print(res.body);
          return false;
        }

        var data = json.decode(res.body);
        var group = data['group'];
        print(group.toString());
        var schedule = data['schedule'];
        print(schedule.toString());

        Group newGroup = Group.fromScheduleJson(group);
        newGroup.addPasscodes(schedule);
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/group/group',
              arguments: newGroup);
        }
      });
      return true;
    }
    return false;
  }

  Future<bool> getMethods() async {
    methods = [];
    final res = await GroupsAPI.getMixMethods();
    if (res.statusCode != 200) {
      print(res.body);
      return false;
    }
    print(res.body);
    var data = json.decode(res.body);
    data = data['mixers'];
    for (var mixers in data) {
      methods.add(mixers['displayName']);
    }
    method = methods.first;
    return true;
  }
}

extension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
