import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Oops! Something went wrong!\nClick the button below to return to the previous screen',
                    style: TextStyle(
                        fontSize: titleFontSize,
                        color: textColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: gold,
              border: Border.all(color: black),
            ),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Go Back',
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: buttonTextColor,
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
