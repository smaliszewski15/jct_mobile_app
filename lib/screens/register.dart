import 'dart:convert';

import 'package:flutter/material.dart';
import '../APIfunctions/userAPI.dart';
import '../components/tooltips.dart';
import '../components/textfields.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  @override
  void initState() {
    fields = {
      'name': CustomTextField(maxLength: 100, fieldName: 'Name', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
      'username' : CustomTextField(maxLength: 255, fieldName: 'Username', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
      'email' : CustomTextField(maxLength: 255, fieldName: 'Email', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
      'phone_number' : CustomTextField(maxLength: 10, fieldName: 'Phone Number', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>(), keyboardType: TextInputType.phone),
      'password' : CustomTextField(maxLength: 60, fieldName: 'Password', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
      'confirmPassword' : CustomTextField(maxLength: 60, fieldName: 'Confirm Password', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
    };
    super.initState();
  }

  @override
  void dispose() {
    fields.forEach((key, value) {
      value.editor.dispose();
    });
    super.dispose();
  }

  void _showSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: WillPopScope(
          onWillPop: () async {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            return true;
          },
          child: Text('Registered successfully. Returning to profile...'),
        ),
        duration: Duration(seconds: 3),
      ),
    ).closed.then((reason) {
      Navigator.pop(context);
    });
  }

  late Map<String, CustomTextField> fields;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/loginpage.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.35),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    color: backgroundColor,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/default-profile-image.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35)),
                          color: Colors.black.withOpacity(.45),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    color: mainSchemeColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() => Navigator.pop(context));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.navigate_before,
                                    ),
                                    Text('Go Back'),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Name*',
                                          style: TextStyle(
                                            fontSize: bioTextSize,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        BasicTooltip(message: "Names must be\n0-100 characters long and\ncan only contain\nASCII characters", tooltipkey: fields['name']!.tooltipKey),
                                      ]
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: fields['name']!,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Username*',
                                          style: TextStyle(
                                            fontSize: bioTextSize,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        BasicTooltip(message: "Usernames must be\n0-24 characters long and\ncan only contain\nASCII characters", tooltipkey: fields['username']!.tooltipKey),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      height: 40,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: fields['username']!,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Phone Number',
                                          style: TextStyle(
                                            fontSize: bioTextSize,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        BasicTooltip(message: "Please enter a phone number", tooltipkey: fields['phone_number']!.tooltipKey),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      height: 40,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: fields['phone_number']!,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Email*',
                                      style: TextStyle(
                                        fontSize: bioTextSize,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    BasicTooltip(message: "Emails must be in the correct email format", tooltipkey: fields['email']!.tooltipKey),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: fields['email']!,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Password*',
                                      style: TextStyle(
                                        fontSize: bioTextSize,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    BasicTooltip(message: "Passwords must be\nat least 8 characters long and\ncan only contain\nASCII characters", tooltipkey: fields['password']!.tooltipKey),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: fields['password']!,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Confirm Password*',
                                      style: TextStyle(
                                        fontSize: bioTextSize,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    BasicTooltip(message: "Please confirm your password", tooltipkey: fields['confirmPassword']!.tooltipKey),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: fields['confirmPassword']!,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: mainSchemeColor,
                                border: Border.all(color: black, width: 3),
                              ),
                              child: OutlinedButton(
                                onPressed: () async {
                                  if (!allRegisterFieldsValid()) {
                                    setState(() {});
                                    return;
                                  }
                                  bool success = await register();
                                  if (!success) {
                                    return;
                                  }
                                  //user = await User().getUserFromStorage();
                                  _showSnack(context);
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: bioTextSize + 10,
                                    color: buttonTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: mainSchemeColor,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.restorablePushReplacementNamed(
                                        context, '/login');
                                  });
                                },
                                child: Row(
                                  children: const <Widget>[
                                    Flexible(
                                      child: Text(
                                          'Have an account? Click to sign in'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> register() async {
    Map<String, dynamic> package = {
      'Name': fields['name']!.editor.value.text,
      'Username': fields['username']!.editor.value.text,
      'Email': fields['Email']!.editor.value.text,
      'Password': fields['Password']!.editor.value.text,
    };
    final res = await UserAPI.register(package);
    if (res.statusCode != 200) {
      return false;
    }

    var data = json.decode(res.body);
    user = User.userFromJson(data);
    return true;
  }

  bool allRegisterFieldsValid() {
    bool toReturn = true;
    fields.forEach((key, value) {
      if (toReturn && key != 'phone_number') {
        toReturn = validateField(value);
      }
    });

    if (!isEmail(fields['email']!.editor.value.text)) {
      fields['email']!.unfilled = true;
      fields['email']!.showToolTip();
      toReturn = false;
    }

    return toReturn;
  }

  bool validateField(CustomTextField field) {
    if (field.editor.value.text.isEmpty) {
      field.unfilled = true;
      field.showToolTip();
      return false;
    }
    return true;
  }
}