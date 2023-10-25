import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class CustomTextField extends StatefulWidget {
  late int maxLength;
  late int minLength;
  late String fieldName;
  late String fieldEntry;
  late GlobalKey<TooltipState> tooltipKey;
  TextEditingController editor = TextEditingController();
  final unfilled = ValueNotifier<bool>(false);
  var keyboardType = TextInputType.text;

  CustomTextField({required this.minLength, required this.maxLength, required this.fieldName, required this.fieldEntry, required this.tooltipKey, this.keyboardType = TextInputType.text});

  bool fieldsMatch(String input) {
    if (input.isEmpty) {
      return false;
    }
    if (editor.value.text != input) {
      return false;
    }
    return true;
  }

  bool validate() {
    if (editor.value.text.length < minLength) {
      return false;
    }
    return true;
  }

  bool isUnfilled() {
    if (editor.value.text.isEmpty) {
      unfilled.value = true;
      return true;
    } else {
      unfilled.value = false;
      return false;
    }
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
    return ValueListenableBuilder<bool>(
        valueListenable: widget.unfilled,
        builder: (_, value, __) {
          return TextField(
            maxLines: 1,
            maxLength: widget.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: widget.editor,
            decoration: widget.unfilled.value
                ? invalidTextField.copyWith(
                hintText: 'Enter ${widget.fieldName}')
                : globalDecoration.copyWith(
                hintText: 'Enter ${widget.fieldName}'),
            style: TextStyle(
              fontSize: smallFontSize,
              color: buttonTextColor,
            ),
            keyboardType: widget.keyboardType,
            onChanged: (field) {
              if (field.isEmpty || field.length > widget.maxLength) {
                widget.showToolTip();
                setState(() => widget.unfilled.value = true);
                return;
              }
              setState(() => widget.unfilled.value = false);
            },
            textAlign: TextAlign.left,
            textInputAction: TextInputAction.next,
          );
        },
    );
  }

}
