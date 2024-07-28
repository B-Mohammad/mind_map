import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NodeModel {
  int id;
  Offset pos;
  String? name;
  Color color;
  String? des;
  String? imagePath;

  NodeModel({
    required this.id,
    required this.pos,
    this.name,
    this.color = Colors.blue,
    this.des,
    this.imagePath,
  });

  Map<String, String?> toMap() {
    return <String, String?>{
      'name': name,
      'des': des,
      'imgUrl': imagePath,
      'color': color.toHexString(),
    };
  }
}
