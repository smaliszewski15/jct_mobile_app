import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../APIfunctions/groupsAPI.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/group.dart';
import '../utils/user.dart';

class IndividualGroup extends StatefulWidget {
  late final String date;
  final bool creator = true;

  IndividualGroup(this.date);

  @override
  _IndividualGroupState createState() => _IndividualGroupState();
}

class _IndividualGroupState extends State<IndividualGroup> {
  List<String> methods = ['Surprise Me', 'IChing', 'Spotlight'];

  bool isEditing = false;

  late String method;

  @override
  void initState() {
    super.initState();
    method = methods.first;
    _concertDate.text = widget.date;
    _title.text = '';
    done = retrieveGroup();
  }

  final _concertDate = TextEditingController();
  final _title = TextEditingController();
  bool titleUnfilled = false;
  late Group group;
  Future<bool>? done;

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
        actions: widget.creator ? <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: invalidColor,
            ),
            iconSize: 35,
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Group?', style: TextStyle(
                        fontSize: titleFontSize, color: black)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 15,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: black, fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: red, fontSize: 18),
                        ),
                      )
                    ],
                    content:
                    const Column(mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                            child: Text(
                                'Are you sure you want to delete this group?')),
                      ],
                    ),
                  );
                },
              );

              if (!mounted) return;

              if (confirm) {
                Navigator.pop(context);
              }
            },
          ),
        ] : null,
        backgroundColor: black,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: backgroundColor),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  child: isEditing ?
                  TextField(
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
                        borderSide: const BorderSide(color: black),
                      ),
                    ) : InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      counterText: '',
                      filled: true,
                      fillColor: mainSchemeColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: invalidColor),
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
                      }
                      setState(() => titleUnfilled = false);
                    },
                    textAlign: TextAlign.center,
                  ) :
                  Text(
                    DateFormat('E, MMM dd, yyyy - hh:mm').format(group.date!),
                    style: TextStyle(
                        fontSize: 30,
                        color: textColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Scheduled Date:',
                        style: defaultTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        DateFormat('E, MMM dd, yyyy - hh:mm').format(group.date!),
                        style: defaultTextStyle,
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Mixing Method: ',
                        style: defaultTextStyle,
                      ),
                      if (isEditing)
                        Container(
                            padding: const EdgeInsets.all(5),
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
                                    child: Text(value),
                                  );
                                },
                                ).toList())
                        )
                      else
                        Text(
                          method,
                          style: defaultTextStyle,
                        ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'Group Leader: ',
                    style: defaultTextStyle,
                  ),
                ),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: black,
                    child: Text(
                      group.groupLeader,
                      style: defaultTextStyle,
                    )
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'Members:',
                    style: defaultTextStyle,
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: group.members.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          color: black,
                          child: Text(
                            group.members[index],
                            style: defaultTextStyle,
                          )
                      );
                    }
                ),
                const Spacer(),
                if (!widget.creator && group.date!.difference(DateTime.now()).inMinutes < 40 && group.members.contains(user!.username))
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 67),
                    decoration: BoxDecoration(
                      color: gold,
                      border: Border.all(color: black, width: 3),
                    ),
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text(
                        'Join Session',
                        style: TextStyle(
                          fontSize: bigButtonFontSize,
                          color: buttonTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (!isEditing && !widget.creator && !group.members.contains(user!.username))
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: gold,
                      border: Border.all(color: black, width: 3),
                    ),
                    child: OutlinedButton(
                      onPressed: () async {
                        if (user == null) {
                          bool confirm = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Not Logged In', style: TextStyle(fontSize: titleFontSize, color: black)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 15,
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text(
                                      'Create an account',
                                      style: TextStyle(color: Colors.red, fontSize: 18),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text(
                                      'Log In',
                                      style: TextStyle(color: black, fontSize: 18),
                                    ),
                                  )
                                ],
                                content:
                                const Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                  Flexible(
                                      child: Text(
                                          'You are currently not logged in. You can either create an account or log in to join this group.')),
                                ]),
                              );
                            },
                          );
                          if (confirm && context.mounted) {
                            Navigator.pushNamed(context, '/login').then((value){
                              if (user != null) {
                                group.members.add(user!.username);
                              }
                            }
                            );
                          } else {
                            if (context.mounted) {
                              Navigator.pushNamed(context, '/register').then((value){
                                if (user != null) {
                                  group.members.add(user!.username);
                                }
                              }
                              );
                            }
                          }
                        }
                      },
                      child: Text(
                        'Join Group',
                        style: TextStyle(
                          fontSize: bigButtonFontSize,
                          color: buttonTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (!isEditing && widget.creator)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: gold,
                      border: Border.all(color: black, width: 3),
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => isEditing = true);
                      },
                      child: Text(
                        'Edit Details',
                        style: TextStyle(
                          fontSize: bigButtonFontSize,
                          color: buttonTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (!isEditing && !widget.creator && (user!.logged ? group.members.contains(user!.username) : false))
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: red,
                      border: Border.all(color: black, width: 3),
                    ),
                    child: OutlinedButton(
                      onPressed: () async {
                        bool confirm = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirm', style: TextStyle(fontSize: titleFontSize, color: black)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 15,
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red, fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(color: black, fontSize: 18),
                                  ),
                                )
                              ],
                              content:
                              const Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                Flexible(
                                    child: Text(
                                        'Are you sure you want to leave this group?')),
                              ]),
                            );
                          },
                        );
                        if (confirm) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Leave Group',
                        style: TextStyle(
                          fontSize: bigButtonFontSize,
                          color: buttonTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (isEditing)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: gold,
                      border: Border.all(color: black, width: 3),
                    ),
                    child: OutlinedButton(
                      onPressed: () async {
                        bool confirm = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirm', style: TextStyle(fontSize: titleFontSize, color: black)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 15,
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red, fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(color: black, fontSize: 18),
                                  ),
                                )
                              ],
                              content:
                              const Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                Flexible(
                                    child: Text(
                                        'Confirm changes made to the group?')),
                              ]),
                            );
                          },
                        );
                        if (!confirm) {
                          return;
                        }
                        group.title = _title.text;
                        setState(() => isEditing = false);
                      },
                      child: Text(
                        'Confirm Changes',
                        style: TextStyle(
                          fontSize: bigButtonFontSize,
                          color: buttonTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (isEditing)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 67),
                    decoration: BoxDecoration(
                      color: red,
                      border: Border.all(color: black, width: 3),
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        _title.text = group.title;
                        setState(() => isEditing = false);
                      },
                      child: Text(
                        'Cancel Changes',
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
    );
  }

  Future<bool> retrieveGroup() async {
    Map<String, dynamic> groupsJSON = GroupsAPI.getGroup;
    if (!groupsJSON.containsKey('group')) {
      return false;
    }
    var data = groupsJSON['group'];
    group = Group.fromJson(data);
    return true;
  }
}
