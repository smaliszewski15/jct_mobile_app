import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../APIfunctions/groupsAPI.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/group.dart';
import '../utils/user.dart';

enum SocketType {
  listener,
  performer,
  maestro
}

class IndividualGroup extends StatefulWidget {
  late final Group group;

  IndividualGroup(this.group);

  @override
  _IndividualGroupState createState() => _IndividualGroupState();
}

class _IndividualGroupState extends State<IndividualGroup> {
  List<String> methods = ['Surprise Me', 'IChing', 'Spotlight'];
  late bool isCreator;

  bool isEditing = false;
  String errorMessage = '';

  late String method;

  @override
  void initState() {
    super.initState();
    //done = retrieveGroup();
    method = methods.first;
    _concertDate.text =
        DateFormat('yyyy-mm-dd HH:mm').format(widget.group.date!);
    _title.text = '';
    isCreator = created();
  }

  final _concertDate = TextEditingController();
  final _title = TextEditingController();
  bool titleUnfilled = false;
  final _passcode = PasscodeAlert();
  final _username = PasscodeAlert();
  //Future<bool>? done;

  bool created() {
    if (user.id != widget.group.maestroID) {
      return false;
    }
    if (user.username != widget.group.maestro) {
      return false;
    }
    return true;
  }

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
        // actions: isCreator
        //     ? <Widget>[
        //         IconButton(
        //           icon: Icon(
        //             Icons.delete,
        //             color: invalidColor,
        //           ),
        //           iconSize: 35,
        //           onPressed: () async {
        //             bool confirm = await showDialog(
        //               context: context,
        //               barrierDismissible: false,
        //               builder: (context) {
        //                 return AlertDialog(
        //                   title: const Text('Delete Group?',
        //                       style: TextStyle(
        //                           fontSize: titleFontSize, color: black)),
        //                   shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(10)),
        //                   elevation: 15,
        //                   actions: <Widget>[
        //                     TextButton(
        //                       onPressed: () {
        //                         Navigator.pop(context, false);
        //                       },
        //                       child: const Text(
        //                         'Cancel',
        //                         style: TextStyle(color: black, fontSize: 18),
        //                       ),
        //                     ),
        //                     TextButton(
        //                       onPressed: () {
        //                         Navigator.pop(context, true);
        //                       },
        //                       child: const Text(
        //                         'Delete',
        //                         style: TextStyle(color: red, fontSize: 18),
        //                       ),
        //                     )
        //                   ],
        //                   content: const Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: <Widget>[
        //                       Flexible(
        //                           child: Text(
        //                               'Are you sure you want to delete this group?')),
        //                     ],
        //                   ),
        //                 );
        //               },
        //             );
        //
        //             if (!mounted) return;
        //
        //             if (confirm) {
        //               Navigator.pop(context);
        //             }
        //           },
        //         ),
        //       ]
        //     : null,
        backgroundColor: black,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScrollView(
          slivers:  <Widget>[
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: isEditing
                    ? TextField(
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
                      borderSide: const BorderSide(color: black),
                    ),
                  )
                      : InputDecoration(
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
                )
                    : Text(
                  widget.group.title,
                  style: TextStyle(fontSize: 30, color: textColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Scheduled Date: ',
                        style: defaultTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        DateFormat('E, MMM dd, yyyy - hh:mm')
                            .format(widget.group.date!),
                        style: defaultTextStyle,
                      )
                    ],
                  ),
                ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Mixing Method: ',
                        style: defaultTextStyle,
                      ),
                      // if (isEditing)
                      //   Container(
                      //       padding: const EdgeInsets.all(5),
                      //       decoration: BoxDecoration(
                      //         color: mainSchemeColor,
                      //         borderRadius: BorderRadius.circular(20),
                      //         border: Border.all(color: black),
                      //       ),
                      //       child: DropdownButton<String>(
                      //           value: method,
                      //           dropdownColor: mainSchemeColor,
                      //           icon: const Icon(Icons.arrow_drop_down,
                      //               color: black),
                      //           onChanged: (String? value) {
                      //             setState(() {
                      //               method = value!;
                      //             });
                      //           },
                      //           items: methods.map<DropdownMenuItem<String>>(
                      //                 (String value) {
                      //               return DropdownMenuItem<String>(
                      //                 value: value,
                      //                 child: Text(value),
                      //               );
                      //             },
                      //           ).toList()))
                      // else
                      Text(
                        method,
                        style: defaultTextStyle,
                      ),
                    ],
                  ),
                ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'Group Leader: ',
                    style: defaultTextStyle,
                  ),
                ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  margin:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  color: black,
                  child: Text(
                    widget.group.maestro,
                    style: defaultTextStyle,
                  ),
                ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'Tags: ',
                    style: defaultTextStyle,
                  ),
                ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  margin:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  color: black,
                  child: Text(
                    widget.group.tags.split('`').join(', '),
                    style: defaultTextStyle,
                  ),
                ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'Description: ',
                    style: defaultTextStyle,
                  ),
                ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  margin:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  color: black,
                  child: Text(
                    widget.group.description,
                    style: defaultTextStyle,
                  ),
                ),
            ),
            if (widget.group.passcodes != null)
              SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    margin:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      'Passcodes: ',
                      style: defaultTextStyle,
                    ),
                  ),
              ),
            if (widget.group.passcodes != null)
              SliverToBoxAdapter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.group.passcodes!.length,
                    itemBuilder: (context, index) {
                      return Text(
                        widget.group.passcodes![index].toString(),
                        style: defaultTextStyle,
                      );
                    },
                  ),
              ),

            //if (widget.group.date!.difference(DateTime.now()).inMinutes < 40)
            SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        'Are you the leader of this group? Or do you want to join in? Or do you just want to listen? Click one of buttons below!',
                        style: TextStyle(
                          fontSize: headingFontSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (user.logged)
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: gold,
                                border: Border.all(color: black, width: 3),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  //UNCOMMENT WHEN NOT DOING UI SHIT
                                  bool logged = await logMaestroIn();
                                  if (!logged) {
                                    setState(() => errorMessage = "You must be logged in to start the concert");
                                    return;
                                  }
                                  bool pass = await getPasscode();
                                  if (!pass) {
                                    setState(() => errorMessage = "You must enter your maestro passcode to start the concert");
                                    _passcode.editor.clear();
                                    return;
                                  }
                                  bool succ = await checkMaestroPasscode();
                                  if (!succ) {
                                    //setState(() => errorMessage = "Password either incorrect or cannot connect to the server");
                                    _passcode.editor.clear();
                                    setState(() {});
                                    return;
                                  }
                                  if (context.mounted) {
                                    _showSnack(context, SocketType.maestro);
                                    return;
                                  }
                                  _passcode.editor.clear();
                                  return;
                                },
                                child: Text(
                                  'Maestro',
                                  style: TextStyle(
                                    fontSize: infoFontSize,
                                    color: buttonTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: gold,
                              border: Border.all(color: black, width: 3),
                            ),
                            margin: const EdgeInsets.all(4),
                            child: TextButton(
                              onPressed:  () async {
                                //UNCOMMENT WHEN NOT DOING UI SHIT
                                bool pass = await getPasscode();
                                if (!pass) {
                                  setState(() => errorMessage = "You must enter a passcode to join the concert");
                                  return;
                                }
                                bool succ = await checkPerformerPasscode();
                                if (!succ) {
                                  setState(() => errorMessage = "Password either incorrect or cannot connect to the server");
                                  _passcode.editor.clear();
                                  return;
                                }
                                if (context.mounted) {
                                  _showSnack(context, SocketType.performer);
                                  return;
                                }
                                _passcode.editor.clear();
                              },
                              child: Text(
                                'Performer',
                                style: TextStyle(
                                  fontSize: infoFontSize,
                                  color: buttonTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: gold,
                              border: Border.all(color: black, width: 3),
                            ),
                            margin: const EdgeInsets.all(4),
                            child: TextButton(
                              onPressed: () async {
                                //UNCOMMENT WHEN NOT DOING UI SHIT
                                bool pass = await getPasscode();
                                if (!pass) {
                                  setState(() => errorMessage = "You must enter a passcode to listen to the concert");
                                  return;
                                }
                                bool succ = await checkListenerPasscode();
                                if (!succ) {
                                  setState(() => errorMessage = "Password either incorrect or cannot connect to the server");
                                  return;
                                }
                                if (context.mounted) {
                                  _showSnack(context, SocketType.listener);
                                  return;
                                }
                              },
                              child: Text(
                                'Listener',
                                style: TextStyle(
                                  fontSize: infoFontSize,
                                  color: buttonTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ),

            // if (!isCreator && widget.group.date!.difference(DateTime.now()).inMinutes < 40)
            //   Container(
            //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 67),
            //     decoration: BoxDecoration(
            //       color: gold,
            //       border: Border.all(color: black, width: 3),
            //     ),
            //     child: OutlinedButton(
            //       onPressed: null,
            //       child: Text(
            //         'Join Session',
            //         style: TextStyle(
            //           fontSize: bigButtonFontSize,
            //           color: buttonTextColor,
            //           fontWeight: FontWeight.w400,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // if (!isEditing && isCreator)
            //   Container(
            //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     padding: const EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //       color: gold,
            //       border: Border.all(color: black, width: 3),
            //     ),
            //     child: OutlinedButton(
            //       onPressed: () {
            //         setState(() => isEditing = true);
            //       },
            //       child: Text(
            //         'Edit Details',
            //         style: TextStyle(
            //           fontSize: bigButtonFontSize,
            //           color: buttonTextColor,
            //           fontWeight: FontWeight.w400,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // if (!isEditing && !isCreator && (user!.logged ? widget.group.members!.contains(user!.username) : false))
            //   Container(
            //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     padding: const EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //       color: red,
            //       border: Border.all(color: black, width: 3),
            //     ),
            //     child: OutlinedButton(
            //       onPressed: () async {
            //         bool confirm = await showDialog(
            //           context: context,
            //           barrierDismissible: false,
            //           builder: (context) {
            //             return AlertDialog(
            //               title: const Text('Confirm', style: TextStyle(fontSize: titleFontSize, color: black)),
            //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //               elevation: 15,
            //               actions: <Widget>[
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.pop(context, false);
            //                   },
            //                   child: const Text(
            //                     'Cancel',
            //                     style: TextStyle(color: Colors.red, fontSize: 18),
            //                   ),
            //                 ),
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.pop(context, true);
            //                   },
            //                   child: const Text(
            //                     'Confirm',
            //                     style: TextStyle(color: black, fontSize: 18),
            //                   ),
            //                 )
            //               ],
            //               content:
            //               const Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            //                 Flexible(
            //                     child: Text(
            //                         'Are you sure you want to leave this group?')),
            //               ]),
            //             );
            //           },
            //         );
            //         if (confirm && context.mounted) {
            //           Navigator.pop(context);
            //         }
            //       },
            //       child: Text(
            //         'Leave Group',
            //         style: TextStyle(
            //           fontSize: bigButtonFontSize,
            //           color: buttonTextColor,
            //           fontWeight: FontWeight.w400,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(5),
            //   margin: const EdgeInsets.symmetric(horizontal: 5),
            //   child: TextField(
            //     maxLines: 1,
            //     controller: _passcode,
            //     decoration: passcodeUnfilled
            //         ? invalidTextField.copyWith(hintText: 'Enter passcode')
            //         : globalDecoration.copyWith(hintText: 'Enter passcode'),
            //     style: TextStyle(
            //       fontSize: bioTextSize + 2,
            //       color: buttonTextColor,
            //     ),
            //     onChanged: (field) {
            //       if (field.isEmpty) {
            //         setState(() => passcodeUnfilled = true);
            //         return;
            //       }
            //       setState(() => passcodeUnfilled = false);
            //     },
            //     textAlign: TextAlign.left,
            //     textInputAction: TextInputAction.next,
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.all(10),
            //   padding: const EdgeInsets.all(5),
            //   child: TextButton(
            //     onPressed: () async {
            //       Map<String, dynamic> query = {
            //         'maestroPasscode': _passcode.value.text,
            //       };
            //
            //       final res = await GroupsAPI.prepare(query);
            //       if (res.statusCode != 200) {
            //         print(res.body);
            //         var message = json.decode(res.body);
            //         errorMessage = message.containsKey('message')
            //             ? message['message']
            //             : message['error'];
            //         return;
            //       }
            //       if (context.mounted) {
            //         _showSnack(context);
            //       }
            //     },
            //     child: Text(
            //       'Prepare concert',
            //       style: buttonTextStyle,
            //     ),
            //   ),
            // ),
            //commented out because the buttons are not used rn
            // if (isEditing && false)
            //   Container(
            //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     padding: const EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //       color: gold,
            //       border: Border.all(color: black, width: 3),
            //     ),
            //     child: OutlinedButton(
            //       onPressed: () async {
            //         bool confirm = await showDialog(
            //           context: context,
            //           barrierDismissible: false,
            //           builder: (context) {
            //             return AlertDialog(
            //               title: const Text('Confirm', style: TextStyle(fontSize: titleFontSize, color: black)),
            //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //               elevation: 15,
            //               actions: <Widget>[
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.pop(context, false);
            //                   },
            //                   child: const Text(
            //                     'Cancel',
            //                     style: TextStyle(color: Colors.red, fontSize: 18),
            //                   ),
            //                 ),
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.pop(context, true);
            //                   },
            //                   child: const Text(
            //                     'Confirm',
            //                     style: TextStyle(color: black, fontSize: 18),
            //                   ),
            //                 )
            //               ],
            //               content:
            //               const Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            //                 Flexible(
            //                     child: Text(
            //                         'Confirm changes made to the group?')),
            //               ]),
            //             );
            //           },
            //         );
            //         if (!confirm) {
            //           return;
            //         }
            //         widget.group.title = _title.text;
            //         setState(() => isEditing = false);
            //       },
            //       child: Text(
            //         'Confirm Changes',
            //         style: TextStyle(
            //           fontSize: bigButtonFontSize,
            //           color: buttonTextColor,
            //           fontWeight: FontWeight.w400,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // if (isEditing)
            //   Container(
            //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 67),
            //     decoration: BoxDecoration(
            //       color: red,
            //       border: Border.all(color: black, width: 3),
            //     ),
            //     child: OutlinedButton(
            //       onPressed: () {
            //         _title.text = widget.group.title;
            //         setState(() => isEditing = false);
            //       },
            //       child: Text(
            //         'Cancel Changes',
            //         style: TextStyle(
            //           fontSize: bigButtonFontSize,
            //           color: buttonTextColor,
            //           fontWeight: FontWeight.w400,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      fontSize: headingFontSize,
                      color: invalidColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ),
          ],
      ),
    ),
    );
  }

  Future<bool> logMaestroIn() async {
    if (user.logged) {
      return true;
    }
    var logged = await showDialog(context: context, builder: (context) {
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
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
                child: Text(
                    'You need to be logged in to be able to start a recording.')),
          ],
        ),
      );
    });

    if (logged == null) {
      return false;
    }

    if (context.mounted) {
      await Navigator.pushNamed(context, logged ? '/login' : '/register');
    }
    return user.logged;
  }

  Future<bool> getPasscode() async {
    bool? gotPasscode = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter your passcode to join the session"),
          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
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
                if (_passcode.unfilled) {
                  return;
                }
                Navigator.pop(context, true);
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          ],
          content: _passcode,
        );
      }
    );

    if (gotPasscode != true) {
      return false;
    }
    return true;
  }

  Future<bool> checkMaestroPasscode() async {
    Map<String, dynamic> query = {
      'maestroPasscode': _passcode.editor.value.text,
    };

    final res = await GroupsAPI.prepare(query);
    if (res.statusCode != 200) {
      print(res.body);
      var message = json.decode(res.body);
      errorMessage = message.containsKey('message')
          ? message['message']
          : message['error'];
      return false;
    }
    return true;
  }

  Future<bool> checkPerformerPasscode() async {
    Map<String, dynamic> query = {
      'performerPasscode': _passcode.editor.value.text,
    };

    final res = await GroupsAPI.validatePerformer(query);
    if (res.statusCode != 200) {
      print(res.body);
      var message = json.decode(res.body);
      errorMessage = message.containsKey('message')
          ? message['message']
          : message['error'];
      return false;
    }
    return true;
  }

  Future<bool> checkListenerPasscode() async {
    Map<String, dynamic> query = {
      'listenerPasscode': _passcode.editor.value.text,
    };

    final res = await GroupsAPI.prepare(query);
    if (res.statusCode != 200) {
      print(res.body);
      var message = json.decode(res.body);
      errorMessage = message.containsKey('message')
          ? message['message']
          : message['error'];
      return false;
    }
    return true;
  }

  void _showSnack(BuildContext context, SocketType type) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: WillPopScope(
              onWillPop: () async {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                return true;
              },
              child: const Text('Passcode read successfully!'),
            ),
            duration: const Duration(seconds: 3),
          ),
        )
        .closed
        .then((reason) async {
          if (!user.logged) {
            bool? gotUsername = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Enter a username to put onto the concert"),
                    shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 15,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text(
                          'Be anonymous',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'Enter name',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                    ],
                    content: _username,
                  );
                }
            );
            if (gotUsername == true) {
              user.username = _username.editor.value.text;
            }
          }
          if (context.mounted) {
            if (type == SocketType.maestro) {
              Navigator.restorablePushNamed(context, '/group/recording/maestro', arguments: _passcode.editor.value.text);
            } else if (type == SocketType.performer) {
              Navigator.restorablePushNamed(context, '/group/recording/performer', arguments: _passcode.editor.value.text);
            } else if (type == SocketType.listener) {
              Navigator.restorablePushNamed(context, '/group/recording/listener', arguments: _passcode.editor.value.text);
            }
          }
    });
  }

  // Future<bool> retrieveGroup() async {
  //   Map<String, dynamic> groupsJSON = GroupsAPI.getGroup;
  //   if (!groupsJSON.containsKey('group')) {
  //     return false;
  //   }
  //   var data = groupsJSON['group'];
  //   group = Group.fromJson(data);
  //   return true;
  // }
}

class PasscodeAlert extends StatefulWidget {
  final editor = TextEditingController();
  bool unfilled = false;

  @override
  _PasscodeAlertState createState() => _PasscodeAlertState();
}

class _PasscodeAlertState extends State<PasscodeAlert> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      controller: widget.editor,
      decoration: widget.unfilled
          ? invalidTextField.copyWith(
          hintText: 'Enter your passcode')
          : globalDecoration.copyWith(
          hintText: 'Enter your passcode'),

      style: TextStyle(
        fontSize: smallFontSize,
        color: buttonTextColor,
      ),
      onChanged: (field) {
        if (field.isEmpty) {
          setState(() => widget.unfilled = true);
          return;
        }
        setState(() => widget.unfilled = false);
      },
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.done,
    );
  }
}
