import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TestProgressIndicatorWidget extends StatelessWidget {
  final String progress;

  TestProgressIndicatorWidget({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 40.0,
      lineWidth: 7.0,
      percent: double.tryParse(progress)!,
      center: Text("${(double.tryParse(progress)! * 100).round()}%",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      progressColor: Color.fromARGB(255, 97, 135, 174),
      backgroundColor: Color.fromARGB(255, 181, 181, 229),
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 1000,
    );
  }
}
