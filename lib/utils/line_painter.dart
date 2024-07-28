import 'package:flutter/material.dart';
import 'package:mind_map/models/edge_model.dart';
import 'package:mind_map/models/node_model.dart';

class LinePainter extends CustomPainter {
  Set<EdgeModel> edges;
  List<NodeModel> nodes;
  bool rebuild;

  LinePainter({required this.edges, required this.nodes, this.rebuild = false});

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in edges) {
      final paint = Paint()
        ..color = element.color
        ..strokeWidth = 2;
      canvas.drawLine(
          nodes.singleWhere((e) => e.id == element.leftNodeId).pos +
              const Offset(80, 45),
          nodes.singleWhere((e) => e.id == element.rightNodeId).pos +
              const Offset(80, 45),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    print("${oldDelegate.rebuild != rebuild}++++");
    return oldDelegate.rebuild != rebuild;
  }
}
