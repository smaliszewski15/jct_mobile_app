import 'dart:convert';

import 'package:flutter/material.dart';
import '../APIfunctions/userAPI.dart';
import '../components/tooltips.dart';
import '../components/textfields.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {


  @override
  void initState() {
    username  = CustomTextField(maxLength: 255, fieldName: 'Username', fieldEntry: user == null ? '' : user!.username, tooltipKey: usernameKey);
    password  = CustomTextField(maxLength: 60, fieldName: 'Password', fieldEntry: '', tooltipKey: passwordKey);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 7),
                      bottom: 50),
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * .95,
                  decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(35)),
                      color: Colors.black.withOpacity(.45)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'John Cage\nTribute',
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width / 1.6,
                          height: MediaQuery.of(context).size.height / 2.3,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(35)),
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
                                    setState(() {
                                      Navigator.pop(context);
                                    });
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
                              const Spacer(),
                              Container(
                                width: 210,
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Username',
                                      style: TextStyle(
                                        fontSize: bioTextSize,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    BasicTooltip(message: "Username cannot be left blank", tooltipkey: usernameKey),
                                  ]
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 210,
                                      height: 40,
                                      child: username,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 210,
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        fontSize: bioTextSize,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    BasicTooltip(message: "Password cannot be left blank", tooltipkey: passwordKey),
                                  ]
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 210,
                                      height: 40,
                                      child: password,
                                    ),
                                  ],
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
                                    if (!allLoginFieldsValid()) {
                                      setState(() {});
                                      return;
                                    }
                                    bool success = await login();
                                    if (success && context.mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  },
                                  child: Text(
                                    'Login',
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
                                          context, '/register');
                                    });
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
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool allLoginFieldsValid() {
    bool toReturn = true;
    if (username.editor.value.text.isEmpty) {
      toReturn = false;
      username.showToolTip();
      setState(() => username.unfilled = true);
    }
    if (password.editor.value.text.isEmpty) {
      toReturn = false;
      password.showToolTip();
      setState(() => password.unfilled = true);
    }
    return toReturn;
  }

  Future<bool> login() async {
    Map<String, dynamic> entries = {
      'identifier': username.editor.value.text,
      'password': password.editor.value.text,
    };

    final res = await UserAPI.login(entries);
    print(res.body);
    print(res.statusCode);
    if (res.statusCode != 200) {
      print(res.body);
      return false;
    }

    var data = json.decode(res.body);
    user = User.userFromJson(data);
    return true;
  }
}