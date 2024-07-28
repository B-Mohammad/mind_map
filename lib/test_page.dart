// // import 'package:flutter/material.dart';
// // import 'package:mind_map/utils/line_painter.dart';

// // void main() {
// //   runApp(MyApp2());
// // }

// // class MyApp2 extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: MovingCircles(),
// //     );
// //   }
// // }

// // class MovingCircles extends StatefulWidget {
// //   @override
// //   _MovingCirclesState createState() => _MovingCirclesState();
// // }

// // class _MovingCirclesState extends State<MovingCircles> {
// //   Offset _circle1Position = Offset(100, 100);
// //   Offset _circle2Position = Offset(300, 300);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Moving Circles'),
// //       ),
// //       body: Stack(
// //         children: [
// //           CustomPaint(
// //             size: Size.infinite,
// //             painter: LinePainter(
// //                 // circle1Position: _circle1Position,
// //                 // circle2Position: _circle2Position),
// //           ),
// //           Positioned(
// //             left: _circle1Position.dx - 25,
// //             top: _circle1Position.dy - 25,
// //             child: MouseRegion(
// //               cursor: SystemMouseCursors.grab,
// //               child: GestureDetector(
// //                 onPanUpdate: (details) {
// //                   setState(() {
// //                     _circle1Position += details.delta;
// //                   });
// //                 },
// //                 child: CircleWidget(),
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             left: _circle2Position.dx - 25,
// //             top: _circle2Position.dy - 25,
// //             child: MouseRegion(
// //               cursor: SystemMouseCursors.grab,
// //               child: GestureDetector(
// //                 onPanUpdate: (details) {
// //                   setState(() {
// //                     _circle2Position += details.delta;
// //                   });
// //                 },
// //                 child: CircleWidget(),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class CircleWidget extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: 50,
// //       height: 50,
// //       decoration: BoxDecoration(
// //         color: Colors.blue,
// //         shape: BoxShape.circle,
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Dialog Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Show Custom Dialog'),
//           onPressed: () {
//             _showCustomDialog(context);
//           },
//         ),
//       ),
//     );
//   }

//   void _showCustomDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: CustomDialogContent(),
//         );
//       },
//     );
//   }
// }

// class CustomDialogContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             'Custom Dialog',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'This is a custom dialog with a container.',
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Enter something',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               TextButton(
//                 child: Text('Cancel'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ElevatedButton(
//                 child: Text('Submit'),
//                 onPressed: () {
//                   // Perform some action here
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'dart:math';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Animated Curve'),
//         ),
//         body: CurveAnimationExample(),
//       ),
//     );
//   }
// }

// class CurveAnimationExample extends StatefulWidget {
//   @override
//   _CurveAnimationExampleState createState() => _CurveAnimationExampleState();
// }

// class _CurveAnimationExampleState extends State<CurveAnimationExample>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Offset getCurvePosition(double t) {
//     // تعریف مسیر منحنی
//     double x = 200 * cos(pi * t);
//     double y = 200 * sin(pi * t);
//     return Offset(x, y);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           Offset position = getCurvePosition(_animation.value);
//           return Transform.translate(
//             offset: position,
//             child: child,
//           );
//         },
//         child: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             shape: BoxShape.circle,
//           ),
//         ),
//       ),
//     );
//   }
// }
