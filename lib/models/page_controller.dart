import 'package:get/get.dart';
import 'package:mind_map/models/edge_model.dart';
import 'package:mind_map/models/node_model.dart';

class PageController extends GetxController {
  List<NodeModel> nodes = [];
  List<EdgeModel> edges = [];

  void deleteNode(int index) {}

  void createNode() {}

  void connectNode(int leftIndex, int rightIndex) {}
}
