/*import 'dart:convert';
import 'dart:io';*/

import 'package:flutter/material.dart';
import '../components/home_drawer.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../components/home_state_manager.dart';

class HomeScreen extends StatefulWidget {
  late final HomeStateManager homeManager;

  HomeScreen({required this.homeManager});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeState>(
        valueListenable: widget.homeManager.buttonNotifier,
        builder: (_, value, __) {
          switch (value) {
            case HomeState.home:
              return Home();
            case HomeState.about_us:
              return AboutUs();
            case HomeState.john_cage:
              return JohnCage();
            case HomeState.upcoming_concerts:
              return Container();
          }
        }
    );
  }

  Widget Home() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 3,
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Image.asset(
                'assets/images/johncage.jpg',
                fit: BoxFit.fitHeight
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    'In honor of John Cage, this project was made in order to express his quote “Everything we do is music”. '
                        'You and up to 4 other friends can sign up and schedule a session. From there, everyone in the session can'
                        'take a recording of any sound and mix them all into one song called a concert. It can be any sound such as '
                        'waves of a beach, birds chirping, sound of a metro passing by, and so much more.',
                    style: TextStyle(
                        fontSize: bioTextSize,
                        color: textColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget AboutUs() {
    return Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  'We are a group of students from UCF creating this project for our Senior Design Project',
                  style: TextStyle(
                      fontSize: bioTextSize,
                      color: textColor
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget JohnCage() {
    return Container();
  }
}
