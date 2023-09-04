import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/textfields.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class AddGroup extends StatefulWidget {

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
    _concertDate.text = DateFormat('E, MMM dd, yyyy - hh:mm').format(_selectedDate);
  }

  final _concertDate = TextEditingController();
  DateTime _selectedDate = DateTime.now();
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
        actions: null,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Every concert must have a title. Enter yours here:',
                    style: TextStyle(
                      fontSize: titleFontSize,
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
                      fontSize: bioTextSize,
                      color: invalidColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                      Flexible(
                        child: SizedBox(
                          child: TextField(
                            textAlign: TextAlign.center,
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: _concertDate,
                            style: defaultTextStyle.copyWith(color: black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              counterText: '',
                              filled: true,
                              fillColor: mainSchemeColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: black),
                              ),
                            ),
                            onTap: () => _selectDate(context),
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
                  child: Text(
                    'Mixing Method: ',
                    style: TextStyle(
                      fontSize: titleFontSize,
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
                              fontSize: bioTextSize,
                            ),
                          ),
                        );
                      },
                      ).toList(),
                    ),
                ),
                //const Spacer(),
                Flexible(
                  child: Text(
                    'Finished making your concert? Tap the button below to create your concert. You will be able to invite people afterwards.',
                    style: TextStyle(
                      fontSize: titleFontSize,
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
                  child: OutlinedButton(
                    onPressed: () {
                      if (_title.value.text.isEmpty) {
                        setState(() => titleUnfilled = true);
                      } else {
                        Navigator.pushReplacementNamed(context, '/groups/group', arguments: _title.value.text);
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
      _selectedDate = newSelectedDate;
      _concertDate.text = DateFormat('E, MMM dd, yyyy - hh:mm').format(newSelectedDate);
    }
    setState(() {});
  }
}
