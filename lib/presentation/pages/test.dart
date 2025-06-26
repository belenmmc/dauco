import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Center(
        child: Text(
          'This is a test page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
