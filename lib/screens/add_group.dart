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
  List<String> methods = ['Surprise Me', 'IChing', 'Spotlight'];
  late String method;

  @override
  void initState() {
    method = methods.first;
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
      body: SingleChildScrollView(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: backgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Scheduled Date:',
                          style: defaultTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd hh:mm').format(widget.date!),
                          style: defaultTextStyle,
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Every concert must have a title. Enter yours here:',
                        style: TextStyle(
                          fontSize: headingFontSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 1,
                      controller: _title,
                      decoration: titleUnfilled ?
                      InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        counterText: '',
                        filled: true,
                        fillColor: mainSchemeColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: invalidColor),
                        ),
                      ) :
                      InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        counterText: '',
                        filled: true,
                        fillColor: mainSchemeColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: black),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: buttonTextColor,
                      ),
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
                  if (titleUnfilled)
                    Text(
                      'You must have a title for your concert',
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: invalidColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      'Mixing Method: ',
                      style: TextStyle(
                        fontSize: headingFontSize,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: mainSchemeColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: black),
                    ),
                    child: DropdownButton<String>(
                      value: method,
                      dropdownColor: mainSchemeColor,
                      icon: const Icon(
                          Icons.arrow_drop_down,
                          color: black),
                      onChanged: (String? value) {
                        setState(() {
                          method = value!;
                        });
                      },
                      items: methods.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: smallFontSize,
                            ),
                          ),
                        );
                      },
                      ).toList(),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Enter a description:',
                        style: TextStyle(
                          fontSize: headingFontSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 1,
                      controller: _description,
                      decoration: descriptionUnfilled ?
                      InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        counterText: '',
                        filled: true,
                        fillColor: mainSchemeColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: invalidColor),
                        ),
                      ) :
                      InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        counterText: '',
                        filled: true,
                        fillColor: mainSchemeColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: black),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: buttonTextColor,
                      ),
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
                  Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'And Lastly some tags:',
                        style: TextStyle(
                          fontSize: headingFontSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 1,
                      controller: _tags,
                      decoration: tagsUnfilled ?
                      InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        counterText: '',
                        filled: true,
                        fillColor: mainSchemeColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: invalidColor),
                        ),
                      ) :
                      InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        counterText: '',
                        filled: true,
                        fillColor: mainSchemeColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: black),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: buttonTextColor,
                      ),
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
                  //const Spacer(),
                  Flexible(
                    child: Text(
                      'Finished making your concert? Tap the button below to create your concert. The invitation codes will be sent to your email.',
                      style: TextStyle(
                        fontSize: headingFontSize,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        style: TextStyle(
                          fontSize: bigButtonFontSize,
                          color: buttonTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<bool> scheduleGroup() async {
    bool logged = await showDialog(context: context, builder: (context) {
      return AlertDialog(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        elevation: 15,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              'Register',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        ],
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Flexible(
                  child: Text(
                      'You need to be logged in to be able to schedule a recording.')),
            ],
        ),
      );
    });

    String date = DateFormat('yyyy-MM-dd').format(widget.date!.toUtc()).toString();
    String time = DateFormat('Hms').format(widget.date!.toUtc()).toString();

    Map<String,dynamic> package = {
      'concertTitle': _title.value.text,
      'concertTags': _tags.value.text,
      'concertDescription': _description.value.text,
      'date': date,
      'time': time,
    };

    if (context.mounted) {
      Navigator.pushNamed(context, logged ? '/login' : '/register').then((entry) async {
        if (!user!.logged) {
          print('not logged');
          return false;
        }
        package['username'] = user!.username;
        package['password'] = user!.password;

        final res = await GroupsAPI.schedule(package);
        print('won');

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
          Navigator.pushReplacementNamed(context, '/group/group', arguments: newGroup);
        }
      });
      return true;
    }
    return false;
  }
}
