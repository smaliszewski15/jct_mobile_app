import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/concert.dart';
import '../utils/globals.dart';

class ConcertCard extends StatefulWidget {
  late final Concert concert;

  ConcertCard({required this.concert});

  @override
  _ConcertCardState createState() => _ConcertCardState();
}

class _ConcertCardState extends State<ConcertCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
        color: accentColor,
      ),
      child: OutlinedButton(
        onPressed: () {
          Navigator.restorablePushNamed(
              context, '/concerts/concert',
              arguments: widget.concert.id);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.concert.title,
                style: TextStyle(
                  fontSize: 24,
                  color: textColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "By: ${widget.concert.maestro}",
                style: TextStyle(
                  fontSize: infoFontSize,
                  color: textColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tags: ${widget.concert.tags.split('`').join(', ')}",
                style: TextStyle(
                  fontSize: infoFontSize,
                  color: textColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recorded on: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.concert.date!)}",
                style: TextStyle(
                  fontSize: infoFontSize,
                  color: textColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
