import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/textfields.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class Group extends StatefulWidget {
  late String groupName;
  final bool creator = true;

  Group(this.groupName);

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  List<String> members = ['person 1', 'numero dos', 'trois', 'Greg'];
  List<String> methods = ['Surprise Me', 'IChing', 'Spotlight'];

  bool isEditing = false;

  late String method;

  @override
  void initState() {
    method = methods.first;
    super.initState();
    _concertDate.text = DateFormat('E, MMM dd, yyyy - hh:mm').format(_selectedDate);
    _title.text = widget.groupName;
  }

  final _concertDate = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _changedDate = DateTime.now();
  final _title = TextEditingController();
  bool titleUnfilled = false;

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
                      Column(mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Flexible(
                                child: Text(
                                    'Are you sure you want to delete this group?')),
                          ],
                      ),
                    );
                  },
                );

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
                    widget.groupName,
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
                      Flexible(
                        child: SizedBox(
                          child: TextField(
                            textAlign: TextAlign.center,
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: _concertDate,
                            style: isEditing ? defaultTextStyle.copyWith(color: black): defaultTextStyle,
                            decoration: isEditing ? InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              counterText: '',
                              filled: true,
                              fillColor: mainSchemeColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: black),
                              ),
                            ) : null,
                            onTap: () {
                              if (isEditing) _selectDate(context);
                            },
                            onChanged: null,
                          ),
                        ),
                      ),
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
                    'Leader Person',
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
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        color: black,
                        child: Text(
                          members[index],
                          style: defaultTextStyle,
                        )
                    );
                  }
                ),
                const Spacer(),
                if (!isEditing && _selectedDate.difference(DateTime.now()).inMinutes < 40)
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
                        _title.text = widget.groupName;
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
                if (!isEditing && !widget.creator)
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
                              Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
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
                if (widget.creator && !isEditing)
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
                        'Invite',
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
                                Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
                                  Flexible(
                                      child: Text(
                                          'Confirm changes made to the group?')),
                                ]),
                              );
                            },
                        );
                        if (!confirm)
                          return;
                        widget.groupName = _title.text;
                        _selectedDate = _changedDate;
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
                        _concertDate.text = DateFormat('E, MMM dd, yyyy - hh:mm').format(_selectedDate);
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

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: mainSchemeColor,
                  onPrimary: black,
                  surface: black,
                  onSurface: textColor,
                ),
                dialogBackgroundColor: backgroundColor,
              ),
              child: child as Widget);
        });

    if (newSelectedDate != null) {
      _changedDate = newSelectedDate;
      _concertDate.text = DateFormat('E, MMM dd, yyyy - hh:mm').format(newSelectedDate);
    }
    setState(() {});
  }
}
