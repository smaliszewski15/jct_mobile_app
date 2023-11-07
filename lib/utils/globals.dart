import 'package:flutter/material.dart';
import 'colors.dart';


//Font Sizes
const double veryLargeFontSize = 60;
const double bigButtonFontSize = 48;
const double titleFontSize = 48;
const double headingFontSize = 28;
const double buttonFontSize = 28;
const double infoFontSize = 20;
const double smallFontSize = 18;
const double extraSmallFontSize = 16;
const double navBarTextSize = 10;

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
  color: textColor,
);

TextStyle buttonTextStyle = TextStyle(
  fontSize: buttonFontSize,
  color: buttonTextColor,
  fontWeight: FontWeight.w400,
);

TextStyle bigButtonTextStyle = TextStyle(
  fontSize: bigButtonFontSize,
  color: buttonTextColor,
  fontWeight: FontWeight.w400,
);

TextStyle headingTextStyle = TextStyle(
  fontSize: headingFontSize,
  color: textColor,
);

TextStyle blackHeadingTextStyle = TextStyle(
  fontSize: headingFontSize,
  color: textfieldTextColor,
);

TextStyle defaultTextStyle = TextStyle(
  fontSize: infoFontSize,
  color: textColor,
);

TextStyle smallTextStyle = TextStyle(
  fontSize: smallFontSize,
  color: textColor,
);

TextStyle blackDefaultTextStyle = TextStyle(
  fontSize: infoFontSize,
  color: textfieldTextColor,
);

TextStyle titleTextStyle = TextStyle(
  fontSize: titleFontSize,
  color: textColor,
);

TextStyle buttonTitleTextStyle = TextStyle(
  fontSize: titleFontSize,
  color: textfieldTextColor,
);

TextStyle invalidTextStyle = TextStyle(
  fontSize: smallFontSize,
  color: invalidColor,
);

TextStyle smallTextFieldTextStyle = TextStyle(
  fontSize: smallFontSize,
  color: buttonTextColor,
);

TextStyle searchTextStyle = TextStyle(
  color: buttonTextColor,
  fontSize: infoFontSize,
);

TextStyle errorTextStyle = TextStyle(fontSize: 10, color: invalidColor);

void updateTextStyles(double scaler) {
  veryLargeTextStyle = TextStyle(
    fontSize: veryLargeFontSize / scaler,
    color: textColor,
  );

  buttonTextStyle = TextStyle(
    fontSize: buttonFontSize / scaler,
    color: buttonTextColor,
    fontWeight: FontWeight.w400,
  );

  bigButtonTextStyle = TextStyle(
    fontSize: bigButtonFontSize / scaler,
    color: buttonTextColor,
    fontWeight: FontWeight.w400,
  );

  headingTextStyle = TextStyle(
    fontSize: headingFontSize / scaler,
    color: textColor,
  );

  blackHeadingTextStyle = TextStyle(
    fontSize: headingFontSize / scaler,
    color: textfieldTextColor,
  );

  defaultTextStyle = TextStyle(
    fontSize: infoFontSize / scaler,
    color: textColor,
  );

  smallTextStyle = TextStyle(
    fontSize: smallFontSize / scaler,
    color: textColor,
  );

  blackDefaultTextStyle = TextStyle(
    fontSize: infoFontSize / scaler,
    color: textfieldTextColor,
  );

  titleTextStyle = TextStyle(
    fontSize: titleFontSize / scaler,
    color: textColor,
  );

  buttonTitleTextStyle = TextStyle(
    fontSize: titleFontSize / scaler,
    color: textfieldTextColor,
  );

  invalidTextStyle = TextStyle(
    fontSize: smallFontSize / scaler,
    color: invalidColor,
  );

  smallTextFieldTextStyle = TextStyle(
    fontSize: smallFontSize / scaler,
    color: buttonTextColor,
  );

  searchTextStyle = TextStyle(
    color: buttonTextColor,
    fontSize: infoFontSize / scaler,
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
