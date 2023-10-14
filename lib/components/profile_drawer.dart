import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class HomeDrawer extends StatefulWidget {

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            child: user!.logged == false ? UserLogin(context) : UserProfile(context)
          ),
          const Spacer(),
          if (user!.logged)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                ),
                child: TextButton(
                  onPressed: () async {
                    bool loggedOut = await user!.logout();
                    if (loggedOut) {
                      user!.logged = false;
                    }
                    setState(() {});
                  },
                  child: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: bioTextSize,
                        color: invalidColor,
                      )
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget UserProfile(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.all(20),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/default-profile-image.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Hello, ${user!.username}!',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                )
              ]
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
          ),
          child: OutlinedButton(
            onPressed: () => Navigator.restorablePushNamed(context, '/profile'),
            child: Text(
              'View Profile',
              style: TextStyle(
                fontSize: titleFontSize,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            )
          )
        )
      ],
    );
  }

  Widget UserLogin(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "You are not currently logged in!",
          style: defaultTextStyle,
          textAlign: TextAlign.center,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          //padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: gold,
            border: Border.all(color: black, width: 3),
          ),
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login').then((entry) => {
                setState(() {})
              });
            },
            child: Text(
              'Log in',
              style: TextStyle(
                fontSize: bioTextSize,
                color: buttonTextColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Text(
          "If you do not have an account, you can create one!",
          style: defaultTextStyle,
          textAlign: TextAlign.center,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          //padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: gold,
            border: Border.all(color: black, width: 3),
          ),
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register').then((entry) => {
                setState(() {})
              });
            },
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: bioTextSize,
                color: buttonTextColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
