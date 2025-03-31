import 'package:dauco/presentation/pages/test_info_page.dart';
import 'package:flutter/material.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TestsListWidget extends StatelessWidget {
  final List<Test> tests;

  const TestsListWidget({
    super.key,
    required this.tests,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...tests.map((test) => _buildTestItem(context, test)).toList(),
        ],
      ),
    );
  }

  Widget _buildTestItem(BuildContext context, Test test) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestInfoPage(test: test),
          ),
        ),
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test ${test.testId.toString()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            'Fecha de alta', test.registeredAt.toString()),
                        _buildInfoRow('Edad cronológica', test.cronologicalAge),
                        _buildInfoRow('Edad evolutiva', test.evolutiveAge),
                      ],
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 7.0,
                    percent: double.tryParse(test.progress)!,
                    center: Text(
                        "${(double.tryParse(test.progress)! * 100).round()}%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    progressColor: Color.fromARGB(255, 76, 77, 176),
                    backgroundColor: Color.fromARGB(255, 167, 168, 213),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
