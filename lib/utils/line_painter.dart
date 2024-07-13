import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  Set<List<Offset>> poses;
  final Color color;

  LinePainter({required this.poses, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    for (var element in poses) {
      canvas.drawLine(element[0], element[1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
