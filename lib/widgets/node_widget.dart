import 'package:flutter/material.dart';
import 'package:mind_map/models/node_model.dart';

class NodeWidget extends StatelessWidget {
  final NodeModel nodeModel;
  final void Function(DragUpdateDetails)? onPanUpdate;
  const NodeWidget({
    super.key,
    required this.nodeModel,
    required this.onPanUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: nodeModel.pos.dx,
      top: nodeModel.pos.dy,
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: GestureDetector(
            onPanUpdate: onPanUpdate,
            //  (details) {
            //   setState(() {
            //     _circle2Position += details.delta;
            //   });
            // },
            child: Container(width: 160,height: 90,padding: EdgeInsets.all(4),
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
                  Image.network(
                    nodeModel.imageUrl ?? "",
                    fit: BoxFit.cover,
                    width: 60,
                    height: 40,
                  ),
                  Text(nodeModel.name ?? "",style: TextStyle(fontSize: 12),),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(style: TextStyle(fontSize: 12),
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
