import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mind_map/models/page_controller.dart';
import 'package:mind_map/utils/line_painter.dart';
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
  late MainPageController controller;

  final FocusNode _focusNode = FocusNode();
  // double minDistance = 40.0;

  List<NodeWidget> createNodeWidget() {
    List<NodeWidget> nodesWidgets = [];
    for (int i = 0; i < controller.nodes.length; i++) {
      // print(controller.nodes[i].pos);
      nodesWidgets.add(NodeWidget(
        onTap: () {
          // print("tap  ${i}");
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

  @override
  Widget build(BuildContext context) {
    controller = Get.put(MainPageController());
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (value) {
        if (value.logicalKey == LogicalKeyboardKey.escape) {
          if (controller.isAddingCircle || controller.isAddingEdge) {
            controller.setIsAddingCircle = false;
            controller.setIsAddingEdge = false;
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
            id: "createNode",
            builder: (controller) {
              return CustomPaint(
                painter: LinePainter(poses: controller.getPoses()),
                // size: Size.infinite,
                child: Stack(
                  children: [
                    ...createNodeWidget(),
                    GetBuilder<MainPageController>(
                        id: "dragPosition",
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
                      onTapDown: (details) {
                        final key = UniqueKey();
                        if (controller.isAddingCircle) {
                          // print(details.localPosition - const Offset(80, 45));
                          // print(details.localPosition);
                          Offset temp =
                              details.localPosition - const Offset(80, 45);
                          controller.createNode(
                              pos: temp, name: "card ${key.hashCode}");
                          controller.setIsAddingCircle = false;
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

  // @override
  // Widget build(BuildContext context) {
  //   return KeyboardListener(
  //     focusNode: _focusNode,
  //     autofocus: true,
  //     onKeyEvent: (event) {
  //       if (event.logicalKey == LogicalKeyboardKey.escape && isAddingCircle) {
  //         setState(() {
  //           isAddingCircle = false;
  //         });
  //       }
  //     },
  //     child: DragTarget<int>(onAcceptWithDetails: (details) {
  //       setState(() {
  //         // int index = circlePositions.indexOf(details.offset);
  //         circlePositions[details.data] = details.offset;
  //         print(details.data);
  //         print(details.offset);
  //         print("+++++++");
  //       });
  //     }, builder: (context, candidateData, rejectedData) {
  //       print(candidateData);
  //       return Stack(
  //         children: [
  //           ...circlePositions.asMap().entries.map((entry) {
  //             int index = entry.key;
  //             Offset position = entry.value;
  //             print(index);
  //             print(position);
  //             return Positioned(
  //               left: position.dx - 20,
  //               top: position.dy - 20,
  //               child: Draggable<int>(
  //                 // key: ValueKey(index),
  //                 data: index,
  //                 feedback: CircleAvatar(
  //                   radius: 20,
  //                   backgroundColor: Colors.blue.withOpacity(0.5),
  //                 ),
  //                 // childWhenDragging: Container(),
  //                 // onDragStarted: () {
  //                 //   setState(() {
  //                 //     isAddingCircle = true;
  //                 //     print("dsf");
  //                 //   });
  //                 // },
  //                 // onDraggableCanceled: (_, __) {},
  //                 // onDragCompleted: () {},
  //                 // onDragEnd: (details) {
  //                 //   setState(() {
  //                 //     circlePositions[index] = details.offset;
  //                 //   });
  //                 // },
  //                 child: const CircleAvatar(
  //                   radius: 20,
  //                   backgroundColor: Colors.blue,
  //                 ),
  //               ),
  //             );
  //           }),
  //           if (isAddingCircle)
  //             Positioned(
  //               left: dragPosition.dx - 20,
  //               top: dragPosition.dy - 20,
  //               child: const IgnorePointer(
  //                 child: Opacity(
  //                   opacity: 0.5,
  //                   child: CircleAvatar(
  //                     radius: 20,
  //                     backgroundColor: Colors.blue,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           GestureDetector(
  //             onTapDown: (details) {
  //               if (isAddingCircle) {
  //                 bool canPlace = true;
  //                 for (var pos in circlePositions) {
  //                   double distance = (details.localPosition - pos).distance;
  //                   if (distance < minDistance) {
  //                     canPlace = false;
  //                     break;
  //                   }
  //                 }
  //                 if (canPlace) {
  //                   setState(() {
  //                     circlePositions.add(details.localPosition);
  //                     isAddingCircle = false;
  //                   });
  //                 }
  //               }
  //             },
  //             child: MouseRegion(
  //               cursor: isAddingCircle
  //                   ? SystemMouseCursors.click
  //                   : MouseCursor.defer,
  //               onHover: (event) {
  //                 if (isAddingCircle) {
  //                   setState(() {
  //                     dragPosition = event.position;
  //                   });
  //                 }
  //               },
  //               child: Container(
  //                 color: Colors.transparent,
  //                 width: double.infinity,
  //                 height: double.infinity,
  //               ),
  //             ),
  //           ),
  //           Align(
  //             alignment: Alignment.bottomCenter,
  //             child:
  // Container(
  //               width: MediaQuery.of(context).size.width / 5,
  //               height: 70,
  //               margin: const EdgeInsets.only(bottom: 24),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(8),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.5),
  //                     spreadRadius: 5,
  //                     blurRadius: 7,
  //                     offset: const Offset(0, 3),
  //                   ),
  //                 ],
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Container(
  //                     width: 50,
  //                     height: 2,
  //                     color: Colors.black,
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         isAddingCircle = true;
  //                       });
  //                     },
  //                     child: const CircleAvatar(
  //                       radius: 20,
  //                       backgroundColor: Colors.blue,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     }),
  //   );
  // }
}
