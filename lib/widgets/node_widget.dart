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
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: GestureDetector(
            onDoubleTap: onDoubleTap,
            onPanUpdate: onPanUpdate,
            onLongPress: onLongPress,
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
                border: Border.all(width: 2, color: nodeModel.color),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  nodeModel.imageUrl!.isNotEmpty
                      ? Image.network(
                          nodeModel.imageUrl ?? "",
                          fit: BoxFit.cover,
                          width: 60,
                          height: 40,
                          // errorBuilder: (context, error, stackTrace) {
                          //   return Icon(
                          //     CupertinoIcons.clear_circled,color: Colors.red,
                          //   );
                          // },
                        )
                      : Container(),
                  Text(
                    nodeModel.name ?? "",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          nodeModel.des ?? ""),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
