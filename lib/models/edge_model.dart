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

  @override
  bool operator ==(covariant EdgeModel other) {
    if (identical(this, other)) return true;

    return other.leftNodeId == leftNodeId && other.rightNodeId == rightNodeId ||
        other.leftNodeId == rightNodeId && other.rightNodeId == leftNodeId;
  }

  @override
  int get hashCode =>
      leftNodeId.hashCode ^ rightNodeId.hashCode;
}
