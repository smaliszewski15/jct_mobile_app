import 'package:flutter/material.dart';
import 'colors.dart';

const double titleFontSize = 32;
const double infoFontSize = 20;
const double bioTextSize = 18;
const double navBarTextSize = 10;
const double bottomIconSize = 40;
const double bigButtonFontSize = 48;

const double maxTextLength = 25;

const double roundedCorners = 20;

RegExp emailValidation = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool isEmail(email) {
  return emailValidation.hasMatch(email);
}

final buttonTextStyle = TextStyle(
  fontSize: infoFontSize,
  color: buttonTextColor,
  fontWeight: FontWeight.w400,
);

final defaultTextStyle = TextStyle(
  fontSize: infoFontSize,
  color: textColor,
);

final BoxDecoration lit = BoxDecoration(
  color: backgroundColor,
  border: Border.all(color: white),
  borderRadius: const BorderRadius.all(Radius.circular(20)),
);

TextStyle errorTextStyle = TextStyle(fontSize: 10, color: invalidColor);

final globalDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
    counterText: '',
    filled: true,
    fillColor: textFieldBackingColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ));

final invalidTextField = globalDecoration.copyWith(
    enabledBorder:
    OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: invalidColor)),
    suffixIcon: Icon(Icons.clear, color: invalidColor),
);

final List<String> maps = ["username", "password", "firstName", "lastName", "email", "phone_number"];

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
