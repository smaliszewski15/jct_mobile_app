import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class CustomTextField extends StatefulWidget {
  late int maxLength;
  late String fieldName;
  late String fieldEntry;
  late GlobalKey<TooltipState> tooltipKey;
  TextEditingController editor = TextEditingController();
  bool unfilled = false;
  var keyboardType = TextInputType.text;

  CustomTextField({required this.maxLength, required this.fieldName, required this.fieldEntry, required this.tooltipKey, this.keyboardType = TextInputType.text});

  bool fieldsMatch(String input) {
    if (input.isEmpty) {
      return false;
    }
    if (editor.value.text != input) {
      return false;
    }
    return true;
  }

  void showToolTip() {
    tooltipKey.currentState?.ensureTooltipVisible();
  }

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}


class _CustomTextFieldState extends State<CustomTextField> {

  @override
  void initState() {
    widget.editor.text = widget.fieldEntry;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      maxLength: widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: widget.editor,
      decoration: widget.unfilled
          ? invalidTextField.copyWith(
          hintText: 'Enter ${widget.fieldName}')
          : globalDecoration.copyWith(
          hintText: 'Enter ${widget.fieldName}'),
      style: TextStyle(
        fontSize: bioTextSize + 2,
        color: buttonTextColor,
      ),
      keyboardType: widget.keyboardType,
      onChanged: (field) {
        if (field.isEmpty || field.length > widget.maxLength) {
          widget.showToolTip();
          setState(() => widget.unfilled = true);
          return;
        }
        setState(() => widget.unfilled = false);
      },
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.next,
    );
  }

}
