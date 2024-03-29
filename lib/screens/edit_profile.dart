import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIfunctions/userAPI.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../models/user.dart';
import '../components/tooltips.dart';
import '../components/textfields.dart';

class EditUserProfilePage extends StatefulWidget {
  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  @override
  void initState() {
    username = CustomTextField(
        minLength: 2,
        maxLength: 255,
        fieldName: 'Username',
        fieldEntry: user.username,
        tooltipKey: GlobalKey<TooltipState>());
    password = CustomTextField(
        minLength: 4,
        maxLength: 60,
        fieldName: 'Password',
        fieldEntry: '',
        tooltipKey: GlobalKey<TooltipState>());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late CustomTextField username, password;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: whiteTitleTextStyle,
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
                        image: AssetImage(
                            'assets/images/default-profile-image.jpg'),
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
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Username',
                                    style: defaultTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  BasicTooltip(
                                      message:
                                          "Usernames must be\n0-24 characters long and\ncan only contain\nASCII characters",
                                      tooltipkey: username.tooltipKey),
                                ]),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(roundedCorners)),
                              ),
                              child: username,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Enter your password to confirm changes',
                                  style: defaultTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                                BasicTooltip(
                                    message:
                                        "Your password is required to confirm the changes",
                                    tooltipkey: password.tooltipKey),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(roundedCorners)),
                              ),
                              child: password,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: mainSchemeColor,
                          border: Border.all(color: black, width: 3),
                        ),
                        child: OutlinedButton(
                          onPressed: () async {
                            bool valid = allFieldsValid();
                            if (!valid) {
                              setState(() => errorMessage = 'Not all fields are filled');
                              return;
                            }

                            try {
                              if (username.editor.value.text !=
                                  user.username) {
                                user.updateUser(username.editor.value.text);
                              }
                              Map<String,dynamic> data = {
                                'UserName': username.editor.value.text,
                              };
                              var res = await UserAPI.updateUser(user.id, data);

                              if (res.statusCode != 200) {
                                print(res.body);
                                return;
                              }
                              user.putUserInStorage();
                              errorMessage = '';
                              if (context.mounted) {
                                _showSnack(context);
                              }
                              return;
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            'Confirm Changes',
                            style: bigButtonTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
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

  bool allFieldsValid() {
    bool toRet = true;
    if (username.isUnfilled()) {
      username.showToolTip();
      toRet = false;
    }
    if (!validatePassword()) {
      password.showToolTip();
      toRet = false;
    }

    return toRet;
  }

  bool validatePassword() {
    if (password.isUnfilled()) {
      return false;
    }
    if (password.editor.value.text != user.password) {
      return false;
    }
    return true;
  }

  void _showSnack(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: WillPopScope(
          onWillPop: () async {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            return true;
          },
          child: const Text('Successfully updated your information'),
        ),
        duration: const Duration(seconds: 3),
      ),
    )
        .closed
        .then((reason) async {
      Navigator.pop(context, true);
    });
  }
}

// class EditPasswordPage extends StatefulWidget {
//   @override
//   _EditPasswordPageState createState() => _EditPasswordPageState();
// }
//
// class _EditPasswordPageState extends State<EditPasswordPage> {
//   @override
//   void initState() {
//     oldPassword = CustomTextField(
//         minLength: 4,
//         maxLength: 60,
//         fieldName: 'Old Password',
//         fieldEntry: '',
//         tooltipKey: GlobalKey<TooltipState>());
//     newPassword = CustomTextField(
//         minLength: 4,
//         maxLength: 60,
//         fieldName: 'New Password',
//         fieldEntry: '',
//         tooltipKey: GlobalKey<TooltipState>());
//     confirmNewPassword = CustomTextField(
//         minLength: 4,
//         maxLength: 60,
//         fieldName: 'Confirm New Password',
//         fieldEntry: '',
//         tooltipKey: GlobalKey<TooltipState>());
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   late CustomTextField oldPassword, newPassword, confirmNewPassword;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Edit Password',
//           style: titleTextStyle,
//         ),
//         centerTitle: true,
//         backgroundColor: accentColor,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.navigate_before,
//             color: white,
//           ),
//           iconSize: 35,
//         ),
//       ),
//       body: Builder(builder: (context) {
//         return GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//           child: SingleChildScrollView(
//             child: Container(
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height -
//                   Scaffold.of(context).appBarMaxHeight!,
//               decoration: BoxDecoration(color: backgroundColor),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           'Old password',
//                           style: defaultTextStyle,
//                           textAlign: TextAlign.center,
//                         ),
//                         BasicTooltip(
//                             message: "Please enter your old password",
//                             tooltipkey: oldPassword.tooltipKey),
//                       ]),
//                   Container(
//                     width: 320,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                           Radius.circular(roundedCorners)),
//                     ),
//                     child: oldPassword,
//                   ),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           'New Password',
//                           style: defaultTextStyle,
//                           textAlign: TextAlign.center,
//                         ),
//                         BasicTooltip(
//                             message:
//                                 "Your new password must be at least 8 characters long",
//                             tooltipkey: newPassword.tooltipKey),
//                       ]),
//                   Container(
//                     width: 320,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(
//                           Radius.circular(roundedCorners)),
//                     ),
//                     child: newPassword,
//                   ),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           'Confirm your new password',
//                           style: defaultTextStyle,
//                           textAlign: TextAlign.center,
//                         ),
//                         BasicTooltip(
//                             message:
//                                 "Write your new password again to confirm changes",
//                             tooltipkey: confirmNewPassword.tooltipKey),
//                       ]),
//                   Container(
//                     width: 320,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(
//                           Radius.circular(roundedCorners)),
//                     ),
//                     child: confirmNewPassword,
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 10),
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: mainSchemeColor,
//                       border: Border.all(color: black, width: 3),
//                     ),
//                     child: OutlinedButton(
//                       onPressed: () async {
//                         if (!validateConfirmPassword()) {
//                           setState(() {});
//                           return;
//                         }
//
//                         if (oldPassword.editor.value.text != user.password) {
//                           oldPassword.unfilled.value = true;
//                           setState(() {});
//                           return;
//                         }
//
//                         if (oldPassword.editor.value.text ==
//                             newPassword.editor.value.text) {
//                           newPassword.unfilled.value = true;
//                           setState(() {});
//                           return;
//                         }
//
//                         try {
//                           final prefs = await SharedPreferences.getInstance();
//
//                           prefs.setString(
//                               'password', newPassword.editor.value.text);
//
//                           Navigator.pop(context);
//                         } catch (e) {
//                           print("Could not open Shared Preferences");
//                         }
//                       },
//                       child: Text(
//                         'Confirm Changes',
//                         style: bigButtonTextStyle,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//       extendBodyBehindAppBar: false,
//       extendBody: false,
//     );
//   }
//
//   bool validateConfirmPassword() {
//     bool toReturn = true;
//     if (oldPassword.isUnfilled()) {
//       toReturn = false;
//       oldPassword.showToolTip();
//     }
//     if (newPassword.isUnfilled()) {
//       toReturn = false;
//       newPassword.showToolTip();
//     }
//     if (confirmNewPassword.isUnfilled()) {
//       toReturn = false;
//       confirmNewPassword.showToolTip();
//     }
//     if (!newPasswordsMatches()) {
//       toReturn = false;
//       newPassword.unfilled.value = true;
//       confirmNewPassword.unfilled.value = true;
//     }
//     return toReturn;
//   }
//
//   bool newPasswordsMatches() {
//     if (newPassword.editor.value.text != confirmNewPassword.editor.value.text) {
//       return false;
//     }
//     return true;
//   }
// }
