import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_map/models/edge_model.dart';
import 'package:mind_map/models/node_model.dart';

class MainPageController extends GetxController {
  List<NodeModel> nodes = [];
  Set<EdgeModel> edges = {};
  bool isAddingCircle = false;
  bool isAddingEdge = false;
  Offset dragPosition = Offset.zero;
  int lock = 0;
  int? selectedNode;

  void deleteNode(int index) {}

  void createNode({
    required Offset pos,
    required String name,
    Color color = Colors.blue,
    String? des,
    String? imageUrl,
  }) {
    nodes.add(NodeModel(
        pos: pos, name: name, color: color, des: des, imageUrl: imageUrl));
    update(["createNode"]);
  }

  void connectNode(int leftIndex, int rightIndex) {}

  set setDragPosition(Offset dragPosition) {
    this.dragPosition = dragPosition;
    update(["dragPosition"]);
  }

  set setIsAddingCircle(bool isAddingCircle) {
    this.isAddingCircle = isAddingCircle;
    update(["isAddingCircle", "dragPosition"]);
  }

  set setIsAddingEdge(bool isAddingEdge) {
    this.isAddingEdge = isAddingEdge;
    update(["isAddingEdge", "dragPosition"]);
  }

  void changeNodePos(int index, Offset pos) {
    nodes[index].pos = pos;
    print("++++$pos");
    update(["createNode"]);
    print(nodes[index].pos);
  }

  void drawLine(int index) {
    if (isAddingEdge) {
      lock++;
      if (lock % 2 == 0 && index != selectedNode) {
        isAddingEdge = false;
        edges.add(EdgeModel(leftNodeId: selectedNode!, rightNodeId: index));

        isAddingEdge = false;
        update(["createNode"]);
      } else if (lock % 2 == 0 && index == selectedNode) {
        selectedNode = null;
      } else {
        selectedNode = index;
      }
    }
    // print(edges);
  }

  Set<List<Offset>> getPoses() {
    Set<List<Offset>> pos = {};
    for (var element in edges) {
      // print(nodes[element.leftNodeId].pos);
      pos.add([
        nodes[element.leftNodeId].pos + const Offset(80, 45),
        nodes[element.rightNodeId].pos + const Offset(80, 45)
      ]);
    }
    // print(pos);
    return pos;
  }
}
