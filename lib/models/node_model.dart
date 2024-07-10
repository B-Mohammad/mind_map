import 'package:flutter/material.dart';

class NodeModel {
  final int id;
  Offset pos;
  String? name;
  Color color;
  String? des;
  String? imageUrl;
  final List<int> child = [];

  set setPos(Offset pos) => this.pos = pos;

  set setName(String name) => this.name = name;

  set setColor(Color color) => this.color = color;

  set setDes(String des) => this.des = des;

  set setImageUrl(String imageUrl) => this.imageUrl = imageUrl;

  set setChild(int nodeId) => child.add(nodeId);

  NodeModel({
    required this.id,
    required this.pos,
    this.name,
    this.color = Colors.blue,
    this.des,
    this.imageUrl,
  });
}
