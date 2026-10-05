import 'package:flutter/material.dart';

const String studentName = 'Nova Krisna';
const String studentId = '2415051117';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('$studentId - $studentName')),
        body: const Center(child: Text('Flutter UI Novametal')),
      ),
    );
  }
}
