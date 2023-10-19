import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class BasicTooltip extends StatelessWidget {
  late String message;
  late GlobalKey<TooltipState> tooltipkey;

  BasicTooltip({required this.message, required this.tooltipkey});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      padding: const EdgeInsets.all(5),
      key: tooltipkey,
      decoration: const BoxDecoration(
        color: Color(0xff4e4e4e),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 2),
      textAlign: TextAlign.center,
      textStyle: TextStyle(
        fontSize: extraSmallFontSize,
        color: textColor,
      ),
      child: Icon(
        Icons.help,
        size: smallFontSize,
        color: textColor,
      ),
    );
  }

  void changeMessage(String newMessage) {
    this.message = newMessage;
  }
}
