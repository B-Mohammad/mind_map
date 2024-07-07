// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class NodeModel {
  int index;
  Offset loc;
  String? name;
  Color? color;
  String? des;
  String? imageUrl;
  NodeModel? child;

  NodeModel({
    required this.index,
    required this.loc,
    this.name,
    this.color = Colors.blue,
    this.des,
    this.imageUrl,
  });
}
