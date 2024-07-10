import 'package:flutter/material.dart';

class CircleLinePainter extends CustomPainter {
  final Offset circle1Position;
  final Offset circle2Position;
  final Color color;

  CircleLinePainter(
      {required this.circle1Position,
      required this.circle2Position,
      this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    canvas.drawLine(circle1Position, circle2Position, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
