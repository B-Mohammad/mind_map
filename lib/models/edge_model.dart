import 'package:flutter/material.dart';

class EdgeModel {
  final int leftNodeId;
  final int rightNodeId;
  final Color color;

  EdgeModel({
    required this.leftNodeId,
    required this.rightNodeId,
    this.color = Colors.blue,
  });
}
