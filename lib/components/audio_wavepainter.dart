import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AudioWaveForms extends CustomPainter {
  final Int16List waveData;
  final Color color;
  final Paint wavePaint;
  final int numSamples;
  final int gap;

  AudioWaveForms({required this.waveData, required this.color, required this.numSamples, this.gap = 2})
      : wavePaint = Paint()
    ..color = color.withOpacity(1.0)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
      double barWidth = width / numSamples;
      double div = waveData.length / numSamples;
      wavePaint.strokeWidth = barWidth - gap;
      for (int i = 0; i < numSamples; i++) {
        int bytePosition = (i * div).ceil();
        double barX = (i * barWidth) + (barWidth / 2);
        final dy = height * (waveData[bytePosition] / 16350);
        canvas.drawLine(
            Offset(barX, height), Offset(barX, height - dy), wavePaint);
      }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}