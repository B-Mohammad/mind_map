import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Circle Demo',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> circlePositions = [];
  bool isAddingCircle = false;
  Offset dragPosition = Offset.zero;

  double minDistance = 40.0; // حداقل فاصله بین دایره‌ها

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
          setState(() {
            isAddingCircle = false;
          });
        }
      },
      child: Stack(
        children: [
          ...circlePositions.asMap().entries.map((entry) {
            int index = entry.key;
            Offset position = entry.value;
            return Positioned(
              left: position.dx - 20,
              top: position.dy - 20,
              child: LongPressDraggable<int>(
                key: ValueKey(index),
                data: index,
                feedback: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.withOpacity(0.5),
                ),
                childWhenDragging: Container(),
                onDragStarted: () {
                  setState(() {
                    isAddingCircle = false;
                  });
                },
                onDraggableCanceled: (_, __) {},
                onDragCompleted: () {},
                onDragEnd: (details) {
                  setState(() {
                    circlePositions[index] = details.offset;
                  });
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                ),
              ),
            );
          }).toList(),
          if (isAddingCircle)
            Positioned(
              left: dragPosition.dx - 20,
              top: dragPosition.dy - 20,
              child: IgnorePointer(
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
              cursor: isAddingCircle ? SystemMouseCursors.click : MouseCursor.defer,
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
              width: MediaQuery.of(context).size.width / 2,
              height: 100,
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
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
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
