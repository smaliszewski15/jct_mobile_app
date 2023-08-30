import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home_screen.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import 'home_state_manager.dart';
import '../utils/user.dart';

class HomeDrawer extends StatefulWidget {
  late HomeStateManager homeState;

  HomeDrawer({required this.homeState});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  List<String> homeNav = ["Home", "About Us", "John Cage", "Upcoming Concerts"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        children: <Widget>[
          DrawerHeader(
            child: user == null ? UserLogin(context) : UserProfile(context),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor,
            ),
            child: OutlinedButton(
              onPressed: () {
                widget.homeState.home();
                setState(() {});
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 24,
                    color: widget.homeState.buttonNotifier.value == HomeState.home ? mainSchemeColor : textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor,
            ),
            child: OutlinedButton(
              onPressed: () {
                widget.homeState.about_us();
                setState(() {});
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "About Us",
                  style: TextStyle(
                    fontSize: 24,
                    color: widget.homeState.buttonNotifier.value == HomeState.about_us ? mainSchemeColor : textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor,
            ),
            child: OutlinedButton(
              onPressed: () {
                widget.homeState.john_cage();
                setState(() {});
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "John Cage",
                  style: TextStyle(
                    fontSize: 24,
                    color: widget.homeState.buttonNotifier.value == HomeState.john_cage ? mainSchemeColor : textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor,
            ),
            child: OutlinedButton(
              onPressed: () {
                widget.homeState.upcoming_concerts();
                setState(() {});
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Upcoming Concerts",
                  style: TextStyle(
                    fontSize: 24,
                    color: widget.homeState.buttonNotifier.value == HomeState.upcoming_concerts ? mainSchemeColor : textColor,
                  ),
                  textAlign: TextAlign.left,
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
        ElevatedButton(
            onPressed: null,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/default-profile-image.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      user!.username,
                      style: buttonTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ]
              ),
            )
        ),
        TextButton(
          onPressed: null,
          child: Text(
            'Log Out',
            style: TextStyle(
              fontSize: bioTextSize,
              color: invalidColor,
            )
          ),
        ),
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
              Navigator.pushNamed(context, '/login');
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
      ],
    );
  }
}
