// import 'package:flutter/material.dart';
// import 'package:mind_map/utils/line_painter.dart';

// void main() {
//   runApp(MyApp2());
// }

// class MyApp2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MovingCircles(),
//     );
//   }
// }

// class MovingCircles extends StatefulWidget {
//   @override
//   _MovingCirclesState createState() => _MovingCirclesState();
// }

// class _MovingCirclesState extends State<MovingCircles> {
//   Offset _circle1Position = Offset(100, 100);
//   Offset _circle2Position = Offset(300, 300);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Moving Circles'),
//       ),
//       body: Stack(
//         children: [
//           CustomPaint(
//             size: Size.infinite,
//             painter: LinePainter(
//                 // circle1Position: _circle1Position,
//                 // circle2Position: _circle2Position),
//           ),
//           Positioned(
//             left: _circle1Position.dx - 25,
//             top: _circle1Position.dy - 25,
//             child: MouseRegion(
//               cursor: SystemMouseCursors.grab,
//               child: GestureDetector(
//                 onPanUpdate: (details) {
//                   setState(() {
//                     _circle1Position += details.delta;
//                   });
//                 },
//                 child: CircleWidget(),
//               ),
//             ),
//           ),
//           Positioned(
//             left: _circle2Position.dx - 25,
//             top: _circle2Position.dy - 25,
//             child: MouseRegion(
//               cursor: SystemMouseCursors.grab,
//               child: GestureDetector(
//                 onPanUpdate: (details) {
//                   setState(() {
//                     _circle2Position += details.delta;
//                   });
//                 },
//                 child: CircleWidget(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CircleWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
