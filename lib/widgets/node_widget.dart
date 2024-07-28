import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mind_map/models/node_model.dart';

class NodeWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Positioned(
      left: nodeModel.pos.dx,
      top: nodeModel.pos.dy,
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        onPanUpdate: onPanUpdate,
        onLongPress: onLongPress,
        child: MouseRegion(
          cursor: SystemMouseCursors.move,
          child: Container(
            width: 160,
            height: 90,
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
              border: Border.all(width: 2, color: nodeModel.color),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Flex(
              direction: Axis.vertical,
              children: [
                if (nodeModel.imagePath!.isNotEmpty)
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(7)),
                      child: Image.file(
                        File(nodeModel.imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // height: 44,
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            nodeModel.name!),
                        if (nodeModel.des!.isNotEmpty)
                          Text(
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              nodeModel.des!),
                      ],
                    ),
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
