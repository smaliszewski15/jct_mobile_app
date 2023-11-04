import 'package:flutter/material.dart';
import '../APIfunctions/userAPI.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      if (user.logged == true) {
        return Profile();
      }
      return notLogged(context);
    } catch (e) {
      print(e.toString());
      return notLogged(context);
    }
  }

  Widget notLogged(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              'You are currently not logged in. You must be logged in to view this page',
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: gold,
              border: Border.all(color: black, width: 3),
            ),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Log in',
                style: bigButtonTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Flexible(
            child: Text(
              'New user? Sign up now!\nYou will be able to join concerts, or even start your own!',
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: gold,
              border: Border.all(color: black, width: 3),
            ),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Sign Up',
                style: bigButtonTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              var delete = await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Deleting your account?'),
                    shape: RoundedRectangleBorder(
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
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          'Delete my account',
                          style: invalidTextStyle,
                        ),
                      )
                    ],
                    content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                              child: Text(
                                  'Are you sure you want to delete your account?')),
                        ]),
                  );
                },
              );

              if (delete != true) {
                return;
              }

              try {
                final res = await UserAPI.deleteUser(user.id);
                if (res.statusCode != 200) {
                  print(res.body);
                  return;
                }
                print(res.body);
                user.logout();
                if (context.mounted) {
                  _showSnack(context);
                }
              } catch (e) {
                print(e);
              }
              setState(() {});
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            iconSize: 35,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: backgroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/default-profile-image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 60),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Text(
                        'Username',
                        style: defaultTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: textFieldBackingColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(roundedCorners)),
                      ),
                      child: Text(
                        user.username == '' ? 'No User Name' : user.username,
                        style: blackDefaultTextStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        'Email',
                        style: defaultTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: textFieldBackingColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(roundedCorners)),
                      ),
                      child: Text(
                        user.email == '' ? 'No Email' : user.email,
                        style: blackDefaultTextStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: gold,
                              border: Border.all(color: black, width: 3),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/profile/edit/information').then((entry) => entry == true ? setState((){}) : null);
                              },
                              child: Text(
                                'Update Profile',
                                style: buttonTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: gold,
                              border: Border.all(color: black, width: 3),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.restorablePushNamed(
                                    context, '/profile/edit/password');
                              },
                              child: Text(
                                'Change Password',
                                style: buttonTextStyle,
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
      ),
    );
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
          child: const Text('Successfully deleted your account!'),
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
