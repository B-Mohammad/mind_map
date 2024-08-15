import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:mind_map/models/edge_model.dart';
import 'package:mind_map/models/page_controller.dart';
import 'package:mind_map/utils/line_painter.dart';
import 'package:mind_map/widgets/custom_dialog_create_node.dart';
import 'package:mind_map/widgets/custom_dialog_delete_node.dart';
import 'package:mind_map/widgets/node_widget.dart';
import 'package:mind_map/widgets/tool_bar_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:mind_map/utils/save_image_stub.dart'
    if (dart.library.html) 'package:mind_map/utils/save_image_web.dart'
    if (dart.library.io) 'package:mind_map/utils/save_image_desktop.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final ScreenshotController screenshotController;
  late final MainPageController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    screenshotController = ScreenshotController();
    _controller = Get.put(MainPageController());
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void saveImage(Uint8List imageData, String fileName) {
    saveImageToDisk(imageData, fileName);
  }

  List<NodeWidget> createNodeWidget() {
    List<NodeWidget> nodesWidgets = [];
    for (int i = 0; i < _controller.nodes.length; i++) {
      nodesWidgets.add(NodeWidget(
        onLongPress: () async {
          debugPrint("long $i");
          if (!_controller.isAddingCircle && !_controller.isAddingEdge) {
            final List<EdgeModel> edgesOfNode = [];
            final List<String> items = [];
            items.add("Node ${_controller.nodes[i].name}");

            for (var element in _controller.edges) {
              if (element.leftNodeId == _controller.nodes[i].id) {
                edgesOfNode.add(element);
                items.add(
                    "Edge connect to node ${_controller.nodes.singleWhere((e) => e.id == element.rightNodeId).name}");
              } else if (element.rightNodeId == _controller.nodes[i].id) {
                edgesOfNode.add(element);
                items.add(
                    "Edge connect to node ${_controller.nodes.singleWhere((e) => e.id == element.leftNodeId).name}");
              }
            }
            final result = await showRemoveCustomDialog(context, items);
            debugPrint(result.toString());
            if (result == 0) {
              _controller.deleteNode(i, edgesOfNode);
            } else if (result != 0 && result != null) {
              _controller.deleteEdge(edgesOfNode[result - 1]);
            }
          }
        },
        onDoubleTap: () async {
          debugPrint("tap  $i");
          if (!_controller.isAddingEdge && !_controller.isAddingCircle) {
            final result = await showDetailCustomDialog(
                context: context, data: _controller.nodes[i].toMap());
            _controller.updateNode(result, i);
          }
          _controller.drawLine(i);
        },
        onPanUpdate: (details) {
          if (!_controller.isAddingCircle && !_controller.isAddingEdge) {
            _controller.changeNodePos(
                i, _controller.nodes[i].pos + details.delta);
          }
        },
        nodeModel: _controller.nodes[i],
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

  MouseCursor setCursor() {
    if (_controller.isAddingCircle || _controller.isAddingEdge) {
      return SystemMouseCursors.click;
    } else {
      return MouseCursor.defer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  _controller.setIsCapMode = true;
                  screenshotController
                      .capture(pixelRatio: 2)
                      .then((Uint8List? image) {
                    if (image != null) {
                      saveImage(image,
                          DateTime.now().millisecondsSinceEpoch.toString());
                    }
                  }).catchError((onError) {
                    print(onError);
                  });
                  Future.delayed(const Duration(milliseconds: 50),
                      () => _controller.setIsCapMode = false);
                },
                child: const Text(
                  "Take Image",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
          title: const Text("Mind Map"),
        ),
        Expanded(
          child: GetBuilder<MainPageController>(builder: (controller) {
            debugPrint("+++rebuild+++");
            return KeyboardListener(
              focusNode: _focusNode,
              autofocus: true,
              onKeyEvent: (value) {
                if (value.logicalKey == LogicalKeyboardKey.escape) {
                  if (_controller.isAddingCircle || _controller.isAddingEdge) {
                    _controller.cancelActs();
                  }
                }
              },
              child: MouseRegion(
                cursor: setCursor(),
                onHover: (event) {
                  controller.setDragPosition = event.localPosition;
                },
                child: Screenshot(
                  controller: screenshotController,
                  child: CustomPaint(
                    painter: LinePainter(
                        edges: controller.edges,
                        nodes: controller.nodes,
                        rebuild: controller.rebuild),
                    size: Size.infinite,
                    child: Stack(
                      children: [
                        ...createNodeWidget(),
                        if (controller.isAddingCircle)
                          Positioned(
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
                          ),
                        if (controller.isAddingEdge)
                          Positioned(
                            left: controller.dragPosition.dx - 35,
                            top: controller.dragPosition.dy - 20,
                            child: IgnorePointer(
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  width: 70,
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
                          ),
                        GestureDetector(
                          onTapDown: (details) async {
                            if (controller.isAddingCircle) {
                              final result = await showDetailCustomDialog(
                                  context: context);
                              debugPrint(result.toString());
                              if (result != null) {
                                controller.createNode(
                                  pos: details.localPosition -
                                      const Offset(80, 45),
                                  des: result["des"],
                                  imageUrl: result["imgUrl"],
                                  name: result["name"],
                                  color: result["color"]!.toColor()!,
                                );
                              }
                            }
                          },
                        ),
                        if (!controller.isCapMode)
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
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
