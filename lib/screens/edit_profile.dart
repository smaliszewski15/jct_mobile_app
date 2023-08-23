import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';
import '../components/tooltips.dart';
import '../components/textfields.dart';

class EditUserProfilePage extends StatefulWidget {

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {

  @override
  void initState() {
    firstName  = CustomTextField(maxLength: 24, fieldName: 'First Name', fieldEntry: user == null ? '' : user!.firstName, tooltipKey: GlobalKey<TooltipState>());
    lastName  = CustomTextField(maxLength: 24, fieldName: 'Last Name', fieldEntry: user == null ? '' : user!.lastName, tooltipKey: GlobalKey<TooltipState>());
    username  = CustomTextField(maxLength: 255, fieldName: 'Username', fieldEntry: user == null ? '' : user!.username, tooltipKey: GlobalKey<TooltipState>());
    email  = CustomTextField(maxLength: 255, fieldName: 'Email', fieldEntry: user == null ? '' : user!.email, tooltipKey: GlobalKey<TooltipState>());
    phoneNumber  = CustomTextField(maxLength: 9, fieldName: 'Phone Number', fieldEntry: user == null ? '' : user!.phoneNumber, tooltipKey: GlobalKey<TooltipState>(), keyboardType: TextInputType.phone);
    password  = CustomTextField(maxLength: 60, fieldName: 'Password', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late CustomTextField firstName, lastName, username, email, phoneNumber, password;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: titleFontSize, color: textColor),
        ),
        centerTitle: true,
        backgroundColor: accentColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
            color: white,
          ),
          iconSize: 35,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: backgroundColor),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'First Name',
                                      style: TextStyle(
                                        fontSize: bioTextSize,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    BasicTooltip(message: "First Names must be\n0-24 characters long and\ncan only contain\nASCII characters", tooltipkey: firstName.tooltipKey),
                                  ]
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(roundedCorners)),
                                ),
                                child: firstName,
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Last Name',
                                      style: TextStyle(
                                        fontSize: bioTextSize,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    BasicTooltip(message: "Last Names must be\n0-24 characters long and\ncan only contain\nASCII characters", tooltipkey: lastName.tooltipKey),
                                  ]
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(roundedCorners)),
                                ),
                                child: lastName,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Username',
                                style: TextStyle(
                                  fontSize: bioTextSize,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              BasicTooltip(message: "Usernames must be\n0-24 characters long and\ncan only contain\nASCII characters", tooltipkey: username.tooltipKey),
                            ]
                          ),
                          Container(
                            width: 320,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorners)),
                            ),
                            child: username,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: bioTextSize,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              BasicTooltip(message: "Emails must be in the correct email format", tooltipkey: email.tooltipKey),
                            ],
                          ),
                          Container(
                            width: 320,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorners)),
                            ),
                            child: email
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontSize: bioTextSize,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              BasicTooltip(message: "Please enter a valid phone number", tooltipkey: phoneNumber.tooltipKey),
                            ],
                          ),
                          Container(
                            width: 320,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorners)),
                            ),
                            child: phoneNumber,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Enter your password to confirm changes',
                                style: TextStyle(
                                  fontSize: bioTextSize,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              BasicTooltip(message: "Your password is required to confirm the changes", tooltipkey: password.tooltipKey),
                            ]
                          ),
                          Container(
                            width: 320,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorners)),
                            ),
                            child: password,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: mainSchemeColor,
                              border: Border.all(color: black, width: 3),
                            ),
                            child: OutlinedButton(
                              onPressed: () async {
                                if (!validateField(firstName)) {
                                  firstName.unfilled = true;
                                  firstName.showToolTip();
                                }
                                if (!validateField(lastName)) {
                                  lastName.unfilled = true;
                                  lastName.showToolTip();
                                }
                                if (!validateField(email)) {
                                  email.unfilled = true;
                                  email.showToolTip();
                                }
                                if (!validateField(username)) {
                                  username.unfilled = true;
                                  username.showToolTip();
                                }
                                if (!validateField(phoneNumber)) {
                                  phoneNumber.unfilled = true;
                                  phoneNumber.showToolTip();
                                }
                                if (!validatePassword()) {
                                  password.unfilled = true;
                                  password.showToolTip();
                                }

                                if (firstName.unfilled || lastName.unfilled || email.unfilled || username.unfilled ||
                                    phoneNumber.unfilled || password.unfilled) {
                                  setState(() {});
                                  return;
                                }

                                try {
                                  final prefs = await SharedPreferences.getInstance();

                                  if (firstName.editor.value.text != user!.firstName) {
                                    prefs.setString('firstName', firstName.editor.value.text);
                                    user!.firstName = firstName.editor.value.text;
                                  }

                                  if (lastName.editor.value.text != user!.lastName) {
                                    prefs.setString('lastName', lastName.editor.value.text);
                                    user!.lastName = lastName.editor.value.text;
                                  }

                                  if (username.editor.value.text != user!.username) {
                                    prefs.setString('username', username.editor.value.text);
                                    user!.username = username.editor.value.text;
                                  }

                                  if (email.editor.value.text != user!.email) {
                                    prefs.setString('email', email.editor.value.text);
                                    user!.email = email.editor.value.text;
                                  }

                                  if (phoneNumber.editor.value.text != user!.phoneNumber) {
                                    prefs.setString('phone_number', phoneNumber.editor.value.text);
                                    user!.phoneNumber = phoneNumber.editor.value.text;
                                  }

                                  Navigator.pop(context);

                                } catch (e) {
                                  print("Could not open Shared Preferences");
                                }
                              },
                              child: Text(
                                'Confirm Changes',
                                style: TextStyle(
                                  fontSize: bioTextSize + 10,
                                  color: buttonTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateField(CustomTextField field) {
    if (field.fieldEntry.isEmpty) {
      return false;
    }
    return true;
  }

  bool validatePassword() {
    if (password.editor.value.text.isEmpty) {
      return false;
    }
    if (password.editor.value.text != user!.password) {
      return false;
    }
    return true;
  }
}

class EditPasswordPage extends StatefulWidget {
  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {

  @override
  void initState() {
    oldPassword  = CustomTextField(maxLength: 60, fieldName: 'Old Password', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>());
    newPassword  = CustomTextField(maxLength: 60, fieldName: 'New Password', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>());
    confirmNewPassword  = CustomTextField(maxLength: 60, fieldName: 'Confirm New Password', fieldEntry: '', tooltipKey: GlobalKey<TooltipState>());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late CustomTextField oldPassword, newPassword, confirmNewPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Password',
          style: TextStyle(fontSize: titleFontSize, color: textColor),
        ),
        centerTitle: true,
        backgroundColor: accentColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
            color: white,
          ),
          iconSize: 35,
        ),
      ),
      body: Builder(
        builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!,
                decoration: BoxDecoration(color: backgroundColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Old password',
                            style: TextStyle(
                              fontSize: infoFontSize,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          BasicTooltip(message: "Please enter your old password", tooltipkey: oldPassword.tooltipKey),
                        ]
                    ),
                    Container(
                      width: 320,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: mainSchemeColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(roundedCorners)),
                      ),
                      child: oldPassword,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'New Password',
                            style: TextStyle(
                              fontSize: infoFontSize,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          BasicTooltip(message: "Your new password must be at least 8 characters long", tooltipkey: newPassword.tooltipKey),
                        ]
                    ),
                    Container(
                      width: 320,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: mainSchemeColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(roundedCorners)),
                      ),
                      child: newPassword,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Confirm your new password',
                            style: TextStyle(
                              fontSize: infoFontSize,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          BasicTooltip(message: "Write your new password again to confirm changes", tooltipkey: confirmNewPassword.tooltipKey),
                        ]
                    ),
                    Container(
                      width: 320,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: mainSchemeColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(roundedCorners)),
                      ),
                      child: confirmNewPassword,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: mainSchemeColor,
                        border: Border.all(color: black, width: 3),
                      ),
                      child: OutlinedButton(
                        onPressed: () async {
                          if (!validateConfirmPassword()) {
                            setState(() {});
                            return;
                          }

                          if (oldPassword.editor.value.text != user!.password) {
                            oldPassword.unfilled = true;
                            setState(() {});
                            return;
                          }

                          if (oldPassword.editor.value.text == newPassword.editor.value.text) {
                            newPassword.unfilled = true;
                            setState(() {});
                            return;
                          }

                          try {
                            final prefs = await SharedPreferences.getInstance();

                            prefs.setString('password', newPassword.editor.value.text);

                            Navigator.pop(context);

                          } catch (e) {
                            print("Could not open Shared Preferences");
                          }
                        },
                        child: Text(
                          'Confirm Changes',
                          style: TextStyle(
                            fontSize: bioTextSize + 10,
                            color: buttonTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
      extendBodyBehindAppBar: false,
      extendBody: false,
    );
  }

  bool validateConfirmPassword() {
    bool toReturn = true;
    if (oldPassword.editor.value.text.isEmpty) {
      toReturn = false;
      oldPassword.unfilled = true;
      oldPassword.showToolTip();
    }
    if (newPassword.editor.value.text.isEmpty) {
      toReturn = false;
      newPassword.unfilled = true;
      newPassword.showToolTip();
    }
    if (confirmNewPassword.editor.value.text.isEmpty) {
      toReturn = false;
      confirmNewPassword.unfilled = true;
      confirmNewPassword.showToolTip();
    }
    if (!newPasswordsMatches()) {
      toReturn = false;
      newPassword.unfilled = true;
      confirmNewPassword.unfilled = true;
    }
    return toReturn;
  }

  bool newPasswordsMatches() {
    if (newPassword.editor.value.text != confirmNewPassword.editor.value.text) {
      return false;
    }
    return true;
  }
}
