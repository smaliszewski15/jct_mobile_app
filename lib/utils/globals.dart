import 'package:flutter/material.dart';
import 'colors.dart';


//Font Sizes
const double veryLargeFontSize = 60;
const double bigButtonFontSize = 50;
const double titleFontSize = 50;
const double headingFontSize = 30;
const double buttonFontSize = 30;
const double infoFontSize = 24;
const double smallFontSize = 20;
const double extraSmallFontSize = 16;
const double navBarTextSize = 12;

//Icon Sizes
const double bottomIconSize = 40;
const double smallIconSize = 20;

const double navBarHeight = 80;
const double roundedCorners = 20;

RegExp emailValidation = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool isEmail(email) {
  return emailValidation.hasMatch(email);
}

//Text Styles
TextStyle veryLargeTextStyle = TextStyle(
  fontSize: veryLargeFontSize,
  color: whiteTextColor,
  fontFamily: 'Balthazar',
);

TextStyle buttonTextStyle = TextStyle(
  fontSize: buttonFontSize,
  color: buttonTextColor,
  fontWeight: FontWeight.w400,
  fontFamily: 'Balthazar',
);

TextStyle bigButtonTextStyle = TextStyle(
  fontSize: bigButtonFontSize,
  color: buttonTextColor,
  fontWeight: FontWeight.w400,
  fontFamily: 'Balthazar',
);

TextStyle headingTextStyle = TextStyle(
  fontSize: headingFontSize,
  color: textColor,
  fontFamily: 'Balthazar',
);

TextStyle blackHeadingTextStyle = TextStyle(
  fontSize: headingFontSize,
  color: textfieldTextColor,
  fontFamily: 'Balthazar',
);

TextStyle defaultTextStyle = TextStyle(
  fontSize: infoFontSize,
  color: textColor,
  fontFamily: 'Balthazar',
);

TextStyle whiteDefaultTextStyle = TextStyle(
  fontSize: infoFontSize,
  color: whiteTextColor,
  fontFamily: 'Balthazar',
);

TextStyle smallTextStyle = TextStyle(
  fontSize: smallFontSize,
  color: textColor,
  fontFamily: 'Balthazar',
);

TextStyle smallWhiteTextStyle = TextStyle(
  fontSize: smallFontSize,
  color: whiteTextColor,
  fontFamily: 'Balthazar',
);

TextStyle titleTextStyle = TextStyle(
  fontSize: titleFontSize,
  color: textColor,
  fontFamily: 'Balthazar',
);

TextStyle whiteTitleTextStyle = TextStyle(
  fontSize: titleFontSize,
  color: whiteTextColor,
  fontFamily: 'Balthazar',
);

TextStyle invalidTextStyle = TextStyle(
  fontSize: smallFontSize,
  color: invalidColor,
  fontFamily: 'Balthazar',
);

TextStyle smallTextFieldTextStyle = TextStyle(
  fontSize: smallFontSize,
  color: buttonTextColor,
  fontFamily: 'Balthazar',
);

TextStyle searchTextStyle = TextStyle(
  color: buttonTextColor,
  fontSize: infoFontSize,
  fontFamily: 'Balthazar',
);

TextStyle errorTextStyle = TextStyle(
  fontSize: 10,
  color: invalidColor,
  fontFamily: 'Balthazar',
);

void updateTextStyles(double scaler) {
  veryLargeTextStyle = TextStyle(
    fontSize: veryLargeFontSize / scaler,
    color: whiteTextColor,
    fontFamily: 'Balthazar',
  );

  buttonTextStyle = TextStyle(
    fontSize: buttonFontSize / scaler,
    color: buttonTextColor,
    fontWeight: FontWeight.w400,
    fontFamily: 'Balthazar',
  );

  bigButtonTextStyle = TextStyle(
    fontSize: bigButtonFontSize / scaler,
    color: buttonTextColor,
    fontWeight: FontWeight.w400,
    fontFamily: 'Balthazar',
  );

  headingTextStyle = TextStyle(
    fontSize: headingFontSize / scaler,
    color: textColor,
    fontFamily: 'Balthazar',
  );

  blackHeadingTextStyle = TextStyle(
    fontSize: headingFontSize / scaler,
    color: textfieldTextColor,
    fontFamily: 'Balthazar',
  );

  defaultTextStyle = TextStyle(
    fontSize: infoFontSize / scaler,
    color: textColor,
    fontFamily: 'Balthazar',
  );

  whiteDefaultTextStyle = TextStyle(
    fontSize: infoFontSize / scaler,
    color: whiteTextColor,
    fontFamily: 'Balthazar',
  );

  smallTextStyle = TextStyle(
    fontSize: smallFontSize / scaler,
    color: textColor,
    fontFamily: 'Balthazar',
  );

  titleTextStyle = TextStyle(
    fontSize: titleFontSize / scaler,
    color: textColor,
    fontFamily: 'Balthazar',
  );

  whiteTitleTextStyle = TextStyle(
    fontSize: titleFontSize / scaler,
    color: whiteTextColor,
    fontFamily: 'Balthazar',
  );

  invalidTextStyle = TextStyle(
    fontSize: smallFontSize / scaler,
    color: invalidColor,
    fontFamily: 'Balthazar',
  );

  smallTextFieldTextStyle = TextStyle(
    fontSize: smallFontSize / scaler,
    color: buttonTextColor,
    fontFamily: 'Balthazar',
  );

  searchTextStyle = TextStyle(
    color: buttonTextColor,
    fontSize: infoFontSize / scaler,
    fontFamily: 'Balthazar',
  );

  smallWhiteTextStyle = TextStyle(
    fontSize: smallFontSize / scaler,
    color: whiteTextColor,
    fontFamily: 'Balthazar',
  );

  updatedTextStyles = true;
}

bool updatedTextStyles = false;

final globalDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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

final List<String> maps = ["ID", "UserName", "Email", "Password"];

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
