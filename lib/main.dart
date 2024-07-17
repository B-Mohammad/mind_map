import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mind_map/models/page_controller.dart';
import 'package:mind_map/utils/line_painter.dart';
import 'package:mind_map/widgets/custom_dialog.dart';
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
        body: const HomePage(), //MyApp2(),
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
  // double minDistance = 40.0;

  List<NodeWidget> createNodeWidget() {
    List<NodeWidget> nodesWidgets = [];
    for (int i = 0; i < controller.nodes.length; i++) {
      // print(controller.nodes[i].pos);
      nodesWidgets.add(NodeWidget(
        onTap: () async {
          print("tap  ${i}");
          if (!controller.isAddingEdge && !controller.isAddingEdge) {
            final result = await _showCustomDialog(
                context: context, data: controller.nodes[i].toMap());
            controller.updateNode(result, i);
          }
          controller.drawLine(i);
        },
        nodeModel: controller.nodes[i],
        onPanUpdate: (details) {
          controller.changeNodePos(i, controller.nodes[i].pos + details.delta);
        },
      ));
    }
    return nodesWidgets;
  }

  Future<Map<String, String?>?> _showCustomDialog(
      {required BuildContext context, Map<String, String?>? data}) {
    return showDialog<Map<String, String?>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CustomDialog(data: data),
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
      child: MouseRegion(
          cursor: controller.isAddingCircle
              ? SystemMouseCursors.click
              : MouseCursor.defer,
          onHover: (event) {
            controller.setDragPosition = event.localPosition;
          },
          child: GetBuilder<MainPageController>(
            // id: "createNode",
            builder: (controller) {
              return CustomPaint(
                painter: LinePainter(poses: controller.getPoses()),
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
                              await _showCustomDialog(context: context);
                          print(result);
                          if (result != null) {
                            controller.createNode(
                                pos: details.localPosition -
                                    const Offset(80, 45),
                                des: result["des"],
                                imageUrl: result["imgUrl"],
                                name: result["name"]);
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
          )),
    );
  }
}
