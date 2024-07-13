import 'dart:ui';
import 'package:get/get.dart';
import 'package:mind_map/models/edge_model.dart';
import 'package:mind_map/models/node_model.dart';

class MainPageController extends GetxController {
  List<NodeModel> nodes = [];
  List<EdgeModel> edges = [];
  bool isAddingCircle = false;
  bool isAddingEdge = false;
  Offset dragPosition = Offset.zero;

  void deleteNode(int index) {}

  void createNode(int id, Offset pos) {
    nodes.add(NodeModel(id: id, pos: pos, name: id.toString()));
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
    update(["createNode"]);
  }
}
