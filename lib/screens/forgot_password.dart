import 'dart:convert';

import 'package:flutter/material.dart';
import '../APIfunctions/userAPI.dart';
import '../components/tooltips.dart';
import '../components/textfields.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class ForgotPage extends StatefulWidget {
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {

  @override
  void initState() {
    email  = CustomTextField(minLength: 2, maxLength: 255, fieldName: 'Email', fieldEntry: '', tooltipKey: emailKey);
    super.initState();
  }

  @override
  void dispose() {
    email.editor.dispose();
    super.dispose();
  }

  late CustomTextField email;
  final GlobalKey<TooltipState> emailKey = GlobalKey<TooltipState>();
  String errorMessage = '';
  bool pageState = false;

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
                        'Forgot Your\nPassword?',
                        style: veryLargeTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  pageState ? confirmSent() : enterEmail(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget enterEmail() {
    return Container(
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
                    'Email',
                    style: smallWhiteTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  BasicTooltip(message: "Email cannot be left blank", tooltipkey: emailKey),
                ]
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            child: email,
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
                if (!fieldsValid()) {
                  errorMessage = 'Email is invalid';
                  setState(() {});
                  return;
                }
                bool success = await forgot();
                if (success) {
                  pageState = true;
                  errorMessage = '';
                }
                setState(() {});
              },
              child: Text(
                'Send',
                style: buttonTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget confirmSent() {
    return Container(
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
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              child: Text(
                'A new password has been sent to your email address. When you receive it, you can come back here and login with that new password!',
                style: whiteDefaultTextStyle,
                textAlign: TextAlign.center,
              )
            ),
          ),
        ],
      ),
    );
  }

  bool fieldsValid() {
    bool toReturn = true;
    if (email.isUnfilled()) {
      toReturn = false;
      email.showToolTip();
    }
    if (!isEmail(email.editor.value.text)) {
      email.unfilled.value = true;
      email.showToolTip();
      toReturn = false;
    }
    return toReturn;
  }

  Future<bool> forgot() async {
    Map<String, dynamic> entries = {
      'email': email.editor.value.text,
    };

    final res = await UserAPI.forgotPassword(entries);
    var data = json.decode(res.body);
    if (res.statusCode != 200) {
      print(data);
      errorMessage = data['data'];
      return false;
    }
    return true;
  }
}