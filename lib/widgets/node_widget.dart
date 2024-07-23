import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mind_map/models/node_model.dart';

class NodeWidget extends StatefulWidget {
  final NodeModel nodeModel;
  final void Function(DragUpdateDetails details)? onPanUpdate;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const NodeWidget({
    super.key,
    required this.nodeModel,
    required this.onPanUpdate,
    required this.onDoubleTap,
    required this.onLongPress,
  });

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  bool isHoverd = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.nodeModel.pos.dx,
      top: widget.nodeModel.pos.dy,
      child: GestureDetector(
        onDoubleTap: widget.onDoubleTap,
        onPanUpdate: widget.onPanUpdate,
        onLongPress: widget.onLongPress,
        child: MouseRegion(
          onEnter: (event) {
            print(isHoverd);
            isHoverd = true;
            setState(() {});
          },
          onExit: (event) {
            print(isHoverd);
            isHoverd = false;
            setState(() {});
          },
          cursor: isHoverd ? SystemMouseCursors.grab : MouseCursor.defer,
          child: Container(
              width: 160,
              height: 90,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
                color: Colors.white,
                border: Border.all(width: 2, color: widget.nodeModel.color),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.nodeModel.imageUrl!.isNotEmpty
                      ? Image.file(
                          File(widget.nodeModel.imageUrl!),
                          fit: BoxFit.cover,
                          width: 60,
                          height: 40,
                        )
                      : Container(),
                  Text(
                    widget.nodeModel.name ?? "",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          widget.nodeModel.des ?? ""),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
