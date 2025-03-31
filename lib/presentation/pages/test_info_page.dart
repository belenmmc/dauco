import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/presentation/widgets/test_info_widget.dart';
import 'package:flutter/material.dart';

class TestInfoPage extends StatefulWidget {
  final Test test;

  const TestInfoPage({super.key, required this.test});

  @override
  _TestInfoPageState createState() => _TestInfoPageState();
}

class _TestInfoPageState extends State<TestInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 168, 213),
      appBar: AppBar(
        title: Text(widget.test.testId.toString()),
        automaticallyImplyLeading: true,
      ),
      body: TestInfoWidget(test: widget.test),
    );
  }
}
