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
  bool temp = false;

  set setTemp(bool temp) {
    this.temp = temp;
    update();
  }

  void cancelActs() {
    selectedNode = null;
    isAddingCircle = false;
    isAddingEdge = false;
    lock = 0;
    update();
  }

  void deleteNode(int index, List<EdgeModel> list) {
    print(index);
    print(list);
    // Set<EdgeModel> temp = {};
    // for (var element in edges) {
    //   if (element.leftNodeId == index || element.rightNodeId == index) {
    //     temp.add(element);
    //   }
    // }
    // print(i);
    edges.removeAll(list.toSet());
    nodes.removeAt(index);
    update();
  }

  void deleteEdge(EdgeModel index) {
    edges.remove(index);
    // print(temp);
    // setTemp = !temp;
    // print(temp);
    setIsAddingEdge = true;
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
        name: id.toString(),
        color: color,
        des: des,
        imageUrl: imageUrl));
    isAddingCircle = false;

    update();
  }

  set setDragPosition(Offset dragPosition) {
    this.dragPosition = dragPosition;
    update();
  }

  set setIsAddingCircle(bool isAddingCircle) {
    this.isAddingCircle = isAddingCircle;
    update();
  }

  set setIsAddingEdge(bool isAddingEdge) {
    this.isAddingEdge = isAddingEdge;
    update();
  }

  void changeNodePos(int index, Offset pos) {
    nodes[index].pos = pos;
    // print("++++$pos");
    update();
    // print(nodes[index].pos);
  }

  void drawLine(int index) {
    if (isAddingEdge) {
      lock++;
      if (lock % 2 == 0 && index != selectedNode) {
        isAddingEdge = false;
        edges.add(EdgeModel(
            leftNodeId: nodes[selectedNode!].id, rightNodeId: nodes[index].id));

        isAddingEdge = false;
      } else if (lock % 2 == 0 && index == selectedNode) {
        selectedNode = null;
      } else {
        selectedNode = index;
      }
    }
    update();
    // print(edges);
  }

  Set<List<Offset>> getPoses() {
    Set<List<Offset>> pos = {};
    for (var element in edges) {
      // print(nodes[element.leftNodeId].pos);
      pos.add([
        nodes.singleWhere((e) => e.id == element.leftNodeId).pos +
            const Offset(80, 45),
        nodes.singleWhere((e) => e.id == element.rightNodeId).pos +
            const Offset(80, 45)
      ]);
    }
    // print(pos);
    // update();
    return pos;
  }

  void updateNode(Map<String, String?>? data, int index) async {
    print(data);
    if (data?["name"] != null) {
      nodes[index].name = data?["name"];
    }
    if (data?["imgUrl"] != null) {
      nodes[index].imageUrl = data?["imgUrl"];
    }
    if (data?["des"] != null) {
      nodes[index].des = data?["des"];
    }
    update();
  }
}
