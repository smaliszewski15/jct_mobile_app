import 'dart:convert';

import 'package:flutter/material.dart';
import '../APIfunctions/userAPI.dart';
import '../components/tooltips.dart';
import '../components/textfields.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../models/user.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {


  @override
  void initState() {
    username  = CustomTextField(minLength: 2, maxLength: 255, fieldName: 'Username', fieldEntry: user.username, tooltipKey: usernameKey);
    password  = CustomTextField(minLength: 4, maxLength: 60, fieldName: 'Password', fieldEntry: '', tooltipKey: passwordKey);
    super.initState();
  }

  @override
  void dispose() {
    username.editor.dispose();
    password.editor.dispose();
    super.dispose();
  }

  late CustomTextField username, password;
  final GlobalKey<TooltipState> usernameKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> passwordKey = GlobalKey<TooltipState>();
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * .95,
                    decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(35)),
                        color: Colors.black.withOpacity(.45)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'John Cage\nTribute',
                        style: veryLargeTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 1.6,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                      color: Colors.black.withOpacity(.45),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
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
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                              children: <Widget>[
                                Text(
                                  'Username',
                                  style: smallWhiteTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                BasicTooltip(message: "Username cannot be left blank", tooltipkey: usernameKey),
                              ]
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          child: username,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                              children: <Widget>[
                                Text(
                                  'Password',
                                  style: smallWhiteTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                BasicTooltip(message: "Password cannot be left blank", tooltipkey: passwordKey),
                              ]
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          child: password,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          margin: const EdgeInsets.all(5),
                          child: Text(
                            errorMessage,
                            style: invalidTextStyle,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: mainSchemeColor,
                            border: Border.all(color: black, width: 3),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (!allLoginFieldsValid()) {
                                setState(() {});
                                return;
                              }
                              bool success = await login();
                              if (success && context.mounted) {
                                Navigator.pop(context, true);
                              }
                              setState(() {});
                            },
                            child: Text(
                              'Login',
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
                              Navigator.restorablePushReplacementNamed(
                                  context, '/register');
                            },
                            child: const Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                      "Don't have an account? Create one now!"),
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
            ),
          ),
        ),
      ),
    );
  }

  bool allLoginFieldsValid() {
    bool toReturn = true;
    if (username.isUnfilled()) {
      toReturn = false;
      username.showToolTip();
    }
    if (password.isUnfilled()) {
      toReturn = false;
      password.showToolTip();
    }
    return toReturn;
  }

  Future<bool> login() async {
    Map<String, dynamic> entries = {
      'identifier': username.editor.value.text,
      'password': password.editor.value.text,
    };

    final res = await UserAPI.login(entries);
    var data = json.decode(res.body);
    if (res.statusCode != 200) {
      errorMessage = data['message'];
      return false;
    }


    user = User.userFromJson(data);
    user.setPassword(password.editor.value.text);
    user.putUserInStorage();
    return true;
  }
}