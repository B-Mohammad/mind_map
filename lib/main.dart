import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mind_map/test_page.dart';

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
        body:  MyApp2(), //HomePage(),
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
  List<Offset> circlePositions = [];
  bool isAddingCircle = false;
  Offset dragPosition = Offset.zero;
  final FocusNode _focusNode = FocusNode();

  double minDistance = 40.0; // حداقل فاصله بین دایره‌ها

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.escape && isAddingCircle) {
          setState(() {
            isAddingCircle = false;
          });
        }
      },
      child: DragTarget<int>(onAcceptWithDetails: (details) {
        setState(() {
          // int index = circlePositions.indexOf(details.offset);
          circlePositions[details.data] = details.offset;
          print(details.data);
          print(details.offset);
          print("+++++++");
        });
      }, builder: (context, candidateData, rejectedData) {
        print(candidateData);
        return Stack(
          children: [
            ...circlePositions.asMap().entries.map((entry) {
              int index = entry.key;
              Offset position = entry.value;
              print(index);
              print(position);
              return Positioned(
                left: position.dx - 20,
                top: position.dy - 20,
                child: Draggable<int>(
                  // key: ValueKey(index),
                  data: index,
                  feedback: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.withOpacity(0.5),
                  ),
                  // childWhenDragging: Container(),
                  // onDragStarted: () {
                  //   setState(() {
                  //     isAddingCircle = true;
                  //     print("dsf");
                  //   });
                  // },
                  // onDraggableCanceled: (_, __) {},
                  // onDragCompleted: () {},
                  // onDragEnd: (details) {
                  //   setState(() {
                  //     circlePositions[index] = details.offset;
                  //   });
                  // },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                  ),
                ),
              );
            }),
            if (isAddingCircle)
              Positioned(
                left: dragPosition.dx - 20,
                top: dragPosition.dy - 20,
                child: const IgnorePointer(
                  child: Opacity(
                    opacity: 0.5,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            GestureDetector(
              onTapDown: (details) {
                if (isAddingCircle) {
                  bool canPlace = true;
                  for (var pos in circlePositions) {
                    double distance = (details.localPosition - pos).distance;
                    if (distance < minDistance) {
                      canPlace = false;
                      break;
                    }
                  }
                  if (canPlace) {
                    setState(() {
                      circlePositions.add(details.localPosition);
                      isAddingCircle = false;
                    });
                  }
                }
              },
              child: MouseRegion(
                cursor: isAddingCircle
                    ? SystemMouseCursors.click
                    : MouseCursor.defer,
                onHover: (event) {
                  if (isAddingCircle) {
                    setState(() {
                      dragPosition = event.position;
                    });
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                height: 70,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 2,
                      color: Colors.black,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAddingCircle = true;
                        });
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
