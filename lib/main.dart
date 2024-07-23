import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mind_map/models/edge_model.dart';
import 'package:mind_map/models/page_controller.dart';
import 'package:mind_map/utils/line_painter.dart';
import 'package:mind_map/widgets/custom_dialog_create_node.dart';
import 'package:mind_map/widgets/custom_dialog_delete_node.dart';
import 'package:mind_map/widgets/node_widget.dart';
import 'package:mind_map/widgets/tool_bar_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mind Map',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Mind Map"),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[200],
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MainPageController controller;
  late final FocusNode _focusNode;

  List<NodeWidget> createNodeWidget() {
    List<NodeWidget> nodesWidgets = [];
    for (int i = 0; i < controller.nodes.length; i++) {
      nodesWidgets.add(NodeWidget(
        onLongPress: () async {
          print("long ${i}");
          if (!controller.isAddingCircle && !controller.isAddingEdge) {
            final List<EdgeModel> indexOfEdges = [];
            final List<String> items = [];
            items.add("Node ${controller.nodes[i].name}");

            for (var element in controller.edges) {
              if (element.leftNodeId == controller.nodes[i].id) {
                indexOfEdges.add(element);
                items.add(
                    "Edge connect to node ${controller.nodes.singleWhere((e) => e.id == element.rightNodeId).name}");
              } else if (element.rightNodeId == controller.nodes[i].id) {
                indexOfEdges.add(element);
                items.add(
                    "Edge connect to node ${controller.nodes.singleWhere((e) => e.id == element.leftNodeId).name}");
              }
            }
            final result = await showRemoveCustomDialog(context, items);
            print(result);
            if (result == 0) {
              controller.deleteNode(i, indexOfEdges);
            } else if (result != 0 && result != null) {
              controller.deleteEdge(indexOfEdges[result - 1]);
            }
          }
        },
        onDoubleTap: () async {
          print("tap  ${i}");
          if (!controller.isAddingEdge && !controller.isAddingCircle) {
            final result = await showDetailCustomDialog(
                context: context, data: controller.nodes[i].toMap());
            controller.updateNode(result, i);
          }
          controller.drawLine(i);
        },
        onPanUpdate: (details) {
          controller.changeNodePos(i, controller.nodes[i].pos + details.delta);
        },
        nodeModel: controller.nodes[i],
      ));
    }
    return nodesWidgets;
  }

  Future<Map<String, String?>?> showDetailCustomDialog(
      {required BuildContext context, Map<String, String?>? data}) {
    return showDialog<Map<String, String?>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CustomDialogCreateNode(data: data),
        );
      },
    );
  }

  Future<int?> showRemoveCustomDialog(
      BuildContext context, List<String> items) {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CustomDialogDeleteNode(items: items),
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = Get.put(MainPageController());
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (value) {
        if (value.logicalKey == LogicalKeyboardKey.escape) {
          if (controller.isAddingCircle || controller.isAddingEdge) {
            controller.cancelActs();
          }
        }
      },
      child: GetBuilder<MainPageController>(
        builder: (controller) => MouseRegion(
          cursor: controller.isAddingCircle
              ? SystemMouseCursors.click
              : MouseCursor.defer,
          onHover: (event) {
            controller.setDragPosition = event.localPosition;
          },
          child: GetBuilder<MainPageController>(
            // id: "createNode",
            builder: (controller) {
              print("abas+++++++++++++++++++++++++++++++++");
              return CustomPaint(
                painter: LinePainter(
                  poses: controller.getPoses(),
                ),
                // size: Size.infinite,
                child: Stack(
                  children: [
                    ...createNodeWidget(),
                    GetBuilder<MainPageController>(
                        // id: "dragPosition",
                        builder: (controller) {
                      if (controller.isAddingCircle) {
                        return Positioned(
                          left: controller.dragPosition.dx - 35,
                          top: controller.dragPosition.dy - 20,
                          child: IgnorePointer(
                            child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.blue),
                                    borderRadius: BorderRadius.circular(4)),
                                child: const Text(
                                  "Node",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (controller.isAddingEdge) {
                        return Positioned(
                          left: controller.dragPosition.dx - 35,
                          top: controller.dragPosition.dy - 20,
                          child: IgnorePointer(
                            child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                width: 70,
                                // height: 40,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.blue, width: 2))),
                                child: const Text(
                                  "Edge",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                    GestureDetector(
                      onTapDown: (details) async {
                        if (controller.isAddingCircle) {
                          final result =
                              await showDetailCustomDialog(context: context);
                          print(result);
                          if (result != null) {
                            controller.createNode(
                              pos: details.localPosition - const Offset(80, 45),
                              des: result["des"],
                              imageUrl: result["imgUrl"],
                              name: result["name"],
                            );
                          }
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ToolBarWidget(
                        edgeOnTap: () {
                          controller.setIsAddingEdge = true;
                        },
                        nodeOnTap: () {
                          controller.setIsAddingCircle = true;
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
