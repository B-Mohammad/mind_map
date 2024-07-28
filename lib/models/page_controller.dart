import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:mind_map/models/edge_model.dart';
import 'package:mind_map/models/node_model.dart';

class MainPageController extends GetxController {
  List<NodeModel> nodes = [];
  Set<EdgeModel> edges = {};
  bool isAddingCircle = false;
  bool isAddingEdge = false;
  bool isDragMode = false;
  Offset dragPosition = Offset.zero;
  int lock = 0;
  int? selectedNode;
  bool rebuild = false;

  void cancelActs() {
    selectedNode = null;
    isAddingCircle = false;
    isAddingEdge = false;
    lock = 0;
    update();
  }

  void deleteNode(int index, List<EdgeModel> list) {
    edges.removeAll(list.toSet());
    nodes.removeAt(index);
    update();
  }

  void deleteEdge(EdgeModel index) {
    edges.remove(index);
    rebuild = !rebuild;
    update();
  }

  void createNode({
    required Offset pos,
    required String? name,
    Color color = Colors.blue,
    String? des,
    String? imageUrl,
  }) {
    final int id = DateTime.now().millisecondsSinceEpoch;
    nodes.add(NodeModel(
        id: id,
        pos: pos,
        name: name,
        color: color,
        des: des,
        imagePath: imageUrl));

    isAddingCircle = false;
    update();
  }

  set setDragPosition(Offset dragPosition) {
    this.dragPosition = dragPosition;
    if (isAddingCircle || isAddingEdge) {
      update();
    }
  }

  set setIsAddingCircle(bool isAddingCircle) {
    if (!isAddingEdge) {
      this.isAddingCircle = isAddingCircle;
    }
    // update();
  }

  set setIsDragMode(bool isDragMode) {
    this.isDragMode = isDragMode;

    // update();
  }

  set setIsAddingEdge(bool isAddingEdge) {
    if (!isAddingCircle) {
      this.isAddingEdge = isAddingEdge;
    }
    // update();
  }

  void changeNodePos(int index, Offset pos) {
    nodes[index].pos = pos;
    update();
  }

  void drawLine(int index) {
    if (isAddingEdge) {
      lock++;
      if (lock % 2 == 0 && index != selectedNode) {
        isAddingEdge = false;
        edges.add(EdgeModel(
            color: nodes[selectedNode!].color,
            leftNodeId: nodes[selectedNode!].id,
            rightNodeId: nodes[index].id));

        isAddingEdge = false;
      } else if (lock % 2 == 0 && index == selectedNode) {
        selectedNode = null;
      } else {
        selectedNode = index;
      }
    }
    update();
  }

  void updateNode(Map<String, String?>? data, int index) async {
    debugPrint(data.toString());
    if (data?["name"] != null) {
      nodes[index].name = data?["name"];
    }
    if (data?["imgUrl"] != null) {
      nodes[index].imagePath = data?["imgUrl"];
    }
    if (data?["des"] != null) {
      nodes[index].des = data?["des"];
    }
    if (data?["color"] != null) {
      nodes[index].color = data?["color"]!.toColor() as Color;
    }
    update();
  }

  // Set<List<Offset>> getPoses() {
  //   Set<List<Offset>> pos = {};
  //   for (var element in edges) {
  //     pos.add([
  //       nodes.singleWhere((e) => e.id == element.leftNodeId).pos +
  //           const Offset(80, 45),
  //       nodes.singleWhere((e) => e.id == element.rightNodeId).pos +
  //           const Offset(80, 45)
  //     ]);
  //   }
  //   return pos;
  // }
}
