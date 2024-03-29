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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Welcome to John Cage Tribute!',
                style: titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 3,
              margin: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                border: Border.all(
                  color: black,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0,3),
                  ),
                ],
              ),
              child: Image.asset(
                  'assets/images/JC.png',
                  fit: BoxFit.cover
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'What is this?',
                style: titleTextStyle,
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
                          'You and up to 4 other friends can sign up and schedule a session. From there, everyone in the session can '
                          'take a recording of any sound and mix them all into one song called a concert. It can be any sound such as '
                          'waves of a beach, birds chirping, sound of a metro passing by, and so much more.',
                      style: smallTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'About Us',
                style: titleTextStyle,
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "Hello, we are a group of students from the University of Central Florida. "
                            "This is the third iteration of the John Cage Tribute Senior Design Project. "
                            "With our project we wanted to encapsulate John Cage's philosophy that anything can be music. "
                            "We worked closely with our Sponsor Richard Leinecker to develop an application that can be used by anyone to make their own unique piece of music.",
                        style: smallTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Meet Our Team',
                style: titleTextStyle,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    border: Border.all(
                      color: black,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0,3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                      'assets/images/Kyle.png',
                      fit: BoxFit.fitWidth
                  ),
                ),
                Text(
                  'Kyle Mason',
                  style: defaultTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Project Manager & Backend Developer',
                  style: defaultTextStyle,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    border: Border.all(
                      color: black,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0,3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                      'assets/images/Demetri.png',
                      fit: BoxFit.fitWidth
                  ),
                ),
                Text(
                  'Demetri',
                  style: defaultTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Backend Developer',
                  style: defaultTextStyle,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    border: Border.all(
                      color: black,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0,3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Image.asset(
                      'assets/images/Rayyan.png',
                      fit: BoxFit.fitWidth
                  ),
                ),
                Text(
                  'Rayyan',
                  style: defaultTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Web Developer',
                  style: defaultTextStyle,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    border: Border.all(
                      color: black,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0,3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Image.asset(
                      'assets/images/Himil.png',
                      fit: BoxFit.fitWidth
                  ),
                ),
                Text(
                  'Himil',
                  style: defaultTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Web Developer',
                  style: defaultTextStyle,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    border: Border.all(
                      color: black,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0,3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Image.asset(
                      'assets/images/Stephen.png',
                      fit: BoxFit.fitWidth
                  ),
                ),
                Text(
                  'Stephen Maliszewski',
                  style: defaultTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Mobile Developer',
                  style: defaultTextStyle,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    border: Border.all(
                      color: black,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0,3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Image.asset(
                      'assets/images/Paul.png',
                      fit: BoxFit.fitWidth
                  ),
                ),
                Text(
                  'Paul',
                  style: defaultTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Database Developer',
                  style: defaultTextStyle,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'About John Cage',
                style: titleTextStyle,
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "John Cage, in full John Milton Cage, Jr. was an American avant-garde composer whose inventitive compositions and unorthodox ideas profoundly influenced mid-20th century music"
                    "\n\nWhile teaching in Seattle (1938-40), Cage organized percussion ensembles to perform his compositions. "
                            "He experimented with his works for dance and subsequent collaborations with the choreographer and dancer Merce Cunningham sparked a long creative and romantic partnership."
                            "\n\nIn the following years, Cage turned to Zen Buddhism and other Eastern philosophies which lead to his conclusion that all activities that makes up the music must be seen as part of a single natural process.",
                        style: smallTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

