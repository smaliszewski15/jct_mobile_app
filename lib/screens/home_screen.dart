/*import 'dart:convert';
import 'dart:io';*/

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
