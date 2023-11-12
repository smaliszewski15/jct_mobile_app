import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../APIfunctions/concertAPI.dart';
import '../APIfunctions/groupsAPI.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../models/group.dart';
import '../models/user.dart';

enum SocketType {
  listener,
  performer,
  maestro
}

class IndividualGroup extends StatefulWidget {
  late final int groupID;

  IndividualGroup(this.groupID);

  @override
  _IndividualGroupState createState() => _IndividualGroupState();
}

class _IndividualGroupState extends State<IndividualGroup> {
  List<String> methods = ['Surprise Me', 'IChing', 'Spotlight'];
  late bool isCreator;
  late Group group;
  Future<bool>? done;
  String errorMessage = '';

  late String method;

  @override
  void initState() {
    super.initState();
    done = retrieveGroup();
    method = methods.first;
    _title.text = '';
  }

  final _concertDate = TextEditingController();
  final _title = TextEditingController();
  bool titleUnfilled = false;
  final _passcode = PasscodeAlert();
  final _username = PasscodeAlert();

  bool created() {
    if (user.id != group.maestroID) {
      return false;
    }
    if (user.username != group.maestro) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: accentColor),
          iconSize: 35,
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        backgroundColor: mainSchemeColor,
      ),
      backgroundColor: backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                  isCreator = created();

                  return CustomScrollView(
                    slivers:  <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            group.title,
                            style: titleTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Scheduled Date: ',
                                style: defaultTextStyle,
                              ),
                              Text(
                                DateFormat('E, MMM dd, yyyy - hh:mm')
                                    .format(group.date!),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Mixing Method: ',
                                style: defaultTextStyle,
                              ),
                              Text(
                                group.mixer == null ? "Default" : group.mixer!.name,
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
                          color: accentColor,
                          child: Text(
                            group.maestro,
                            style: whiteDefaultTextStyle,
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
                          color: accentColor,
                          child: Text(
                            group.tags.split('`').join(', '),
                            style: whiteDefaultTextStyle,
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
                          color: accentColor,
                          child: Text(
                            group.description,
                            style: whiteDefaultTextStyle,
                          ),
                        ),
                      ),
                      if (passcodes.isNotEmpty)
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
                      if (passcodes.isNotEmpty)
                        SliverToBoxAdapter(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: passcodes.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: <Widget>[
                                  if (index == 0)
                                    Text(
                                      'Maestro Passcode: ',
                                      style: defaultTextStyle,
                                    ),
                                  if (index == passcodes.length - 1)
                                    Text(
                                      'Listener Passcode: ',
                                      style: defaultTextStyle,
                                    ),
                                  if (index != 0 && index != passcodes.length - 1)
                                    Text(
                                      'User$index Passcode: ',
                                      style: defaultTextStyle,
                                    ),
                                  Text(
                                    passcodes[index].toString(),
                                    style: defaultTextStyle,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                      if (group.date!.difference(DateTime.now()).inMinutes < 40)
                        SliverToBoxAdapter(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  'Are you the leader of this group? Or do you want to join in? Or do you just want to listen? Click one of buttons below!',
                                  style: headingTextStyle,
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
                                          color: mainSchemeColor,
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
                                            style: smallTextStyle.copyWith(
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
                                        color: mainSchemeColor,
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
                                          style: smallTextStyle.copyWith(
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
                                        color: mainSchemeColor,
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
                                            setState(() {});
                                            return;
                                          }
                                          if (context.mounted) {
                                            _showSnack(context, SocketType.listener);
                                            return;
                                          }
                                        },
                                        child: Text(
                                          'Listener',
                                          style: smallTextStyle.copyWith(
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
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            errorMessage,
                            style: invalidTextStyle.copyWith(
                              fontSize: headingFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
              }
            }
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

    if (logged != true && logged != false) {
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
              child: Text(
                'Cancel',
                style: invalidTextStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                if (_passcode.unfilled) {
                  return;
                }
                Navigator.pop(context, true);
              },
              child: Text(
                'Submit',
                style: invalidTextStyle,
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

    final res = await GroupsAPI.validateListener(query);
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
                        child: Text(
                          'Be anonymous',
                          style: invalidTextStyle,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          'Enter name',
                          style: invalidTextStyle,
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

  Future<bool> retrieveGroup() async {
    Map<String, dynamic> query = {
      'id': '${widget.groupID}',
    };

    final res = await ConcertsAPI.getSongData(query);

    if (res.statusCode != 200) {
      return false;
    }

    var data = json.decode(res.body);
    if (!data.containsKey('group')) {
      return false;
    }

    group = Group.fromScheduleJson(data['group']);

    _concertDate.text =
       DateFormat('yyyy-mm-dd HH:mm').format(group.date!);

    return true;
  }
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

      style: smallTextFieldTextStyle,
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
