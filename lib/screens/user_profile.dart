import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class UserProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    try {
      if (user!.logged == true) {
        return Profile();
      } else {
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
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: textColor,
                  ),
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
                    style: TextStyle(
                      fontSize: bigButtonFontSize,
                      color: buttonTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  'New user? Sign up now!\nYou will be able to join concerts, or even start your own!',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: textColor,
                  ),
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
        );
      }
    }
    catch(e) {
      print(e.toString());
      return Container();
    }
  }
}

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  image: AssetImage('assets/images/default-profile-image.jpg'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'First Name',
                            style: TextStyle(
                              fontSize: bioTextSize,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: 150,
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 7),
                            decoration: BoxDecoration(
                              color: textFieldBackingColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(roundedCorners)),
                            ),
                            child: Text(
                              user!.firstName == '' ? 'No First Name' : user!.firstName,
                              style: TextStyle(
                                fontSize: bioTextSize,
                                color: buttonTextColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Last Name',
                            style: TextStyle(
                              fontSize: bioTextSize,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                              color: textFieldBackingColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(roundedCorners)),
                            ),
                            child: Text(
                              user!.lastName == '' ? 'No Last Name' : user!.lastName,
                              style: TextStyle(
                                fontSize: bioTextSize,
                                color: buttonTextColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Username',
                        style: TextStyle(
                          fontSize: bioTextSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        color: textFieldBackingColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(roundedCorners)),
                      ),
                      child: Text(
                        user!.username == '' ? 'No User Name' : user!.username,
                        style: TextStyle(
                          fontSize: bioTextSize,
                          color: buttonTextColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: bioTextSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        color: textFieldBackingColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(roundedCorners)),
                      ),
                      child: Text(
                        user!.email == '' ? 'No Email' : user!.email,
                        style: TextStyle(
                          fontSize: bioTextSize,
                          color: buttonTextColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: bioTextSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: textFieldBackingColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(roundedCorners)),
                      ),
                      child: Text(
                        user!.phoneNumber == '' ? 'No Phone Number' : user!.phoneNumber,
                        style: TextStyle(
                          fontSize: bioTextSize,
                          color: buttonTextColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: gold,
                          border: Border.all(color: black, width: 3),
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/profile/edit/information');
                          },
                          child: Text(
                            'Edit Information',
                            style: TextStyle(
                              fontSize: infoFontSize,
                              color: buttonTextColor,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                            style: TextStyle(
                              fontSize: infoFontSize,
                              color: buttonTextColor,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
