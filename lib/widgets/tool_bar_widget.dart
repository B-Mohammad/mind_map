import 'package:flutter/material.dart';

class ToolBarWidget extends StatelessWidget {
  final void Function()? nodeOnTap;
  final void Function()? edgeOnTap;

  const ToolBarWidget({
    super.key,
    required this.nodeOnTap,
    required this.edgeOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200),
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
          Tooltip(
            message: "Edge",
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: edgeOnTap,
                child: Container(
                  width: 70,
                  // height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 2))),
                  child: const Text(
                    "Edge",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          Tooltip(
            message: "Node",
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: nodeOnTap,
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text(
                    "Node",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
