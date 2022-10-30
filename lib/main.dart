import 'package:flutter/material.dart';
import 'package:test_esign/coachmarks/main_cm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final String name = "Flutter Demo";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainCoachMarksPage(
        title: name,
      ),
    );
  }
}
