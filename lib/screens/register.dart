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
      'username' : CustomTextField(minLength: 2, maxLength: 255, fieldName: 'Username', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
      'email' : CustomTextField(minLength: 10, maxLength: 255, fieldName: 'Email', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
      'password' : CustomTextField(minLength: 4, maxLength: 60, fieldName: 'Password', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
      'confirmPassword' : CustomTextField(minLength: 4, maxLength: 60, fieldName: 'Confirm Password', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>()),
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
  String errorMessage = '';

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
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: smallTextStyle.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() => Navigator.pop(context));
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.navigate_before,
                                    ),
                                    Text('Go Back'),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(5),
                              child: Text(
                                '* = Required',
                                style: invalidTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Username',
                                  style: smallTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                    '*',
                                    style: smallTextStyle,
                                ),
                                BasicTooltip(message: "Usernames must be 2-24 characters long and\ncan only contain ASCII characters", tooltipkey: fields['username']!.tooltipKey),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 5),
                              child: fields['username']!,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Email',
                                  style: smallTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                    '*',
                                    style: smallTextStyle,
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
                            Row(
                              children: <Widget>[
                                Text(
                                  'Password',
                                  style: smallTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                    '*',
                                    style: smallTextStyle,
                                ),
                                BasicTooltip(message: "Passwords must be at least 4 characters long and\ncan only contain ASCII characters", tooltipkey: fields['password']!.tooltipKey),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 5),
                              child: fields['password']!,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Confirm Password',
                                  style: smallTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                    '*',
                                    style: smallTextStyle,
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 20,
                              margin: const EdgeInsets.all(5),
                              child: Text(
                                errorMessage,
                                style: smallTextStyle,
                              ),
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
                                  style: buttonTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: smallTextStyle.copyWith(
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
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                          'Have an account? Click to sign in',
                                      ),
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
      'UserName': fields['username']!.editor.value.text,
      'Email': fields['email']!.editor.value.text,
      'Password': fields['password']!.editor.value.text,
    };
    final res = await UserAPI.register(package);
    var data = json.decode(res.body);
    print(res.body);
    if (res.statusCode != 201) {
      print(res.statusCode);
      errorMessage = data['message'];
      return false;
    }

    user = User.userFromJson(data);
    user.setPassword(fields['password']!.editor.value.text);
    return true;
  }

  bool allRegisterFieldsValid() {
    bool toReturn = true;
    fields.forEach((key, value) {
      if (value.isUnfilled() || !value.validate()) {
        toReturn = false;
        value.showToolTip();
        errorMessage = 'Fields are invalid';
      }
    });

    if (!isEmail(fields['email']!.editor.value.text)) {
      fields['email']!.unfilled.value = true;
      fields['email']!.showToolTip();
      toReturn = false;
    }

    if (fields['password']!.editor.value.text != fields['confirmPassword']!.editor.value.text) {
      fields['confirmPassword']!.unfilled.value = true;
      fields['confirmPassword']!.showToolTip();
      toReturn = false;
    }

    return toReturn;
  }
}