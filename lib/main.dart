import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_map/screens/main_page.dart';

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
        backgroundColor: Colors.grey[200],
        body: const MainPage(),
      ),
    );
  }
}
