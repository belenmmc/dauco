import 'package:dauco/presentation/pages/test_info_page.dart';
import 'package:dauco/presentation/widgets/test_progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:dauco/domain/entities/test.entity.dart';

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
          ...tests.map((test) => _buildTestCard(context, test)).toList(),
        ],
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, Test test) {
    return _TestCard(test: test);
  }
}

class _TestCard extends StatefulWidget {
  final Test test;

  const _TestCard({required this.test});

  @override
  State<_TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<_TestCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestInfoPage(test: widget.test),
            ),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: _isHovered
                  ? Color.fromARGB(255, 230, 240, 250)
                  : Color.fromARGB(255, 248, 251, 255),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test ${widget.test.testId.toString()}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Fecha de alta',
                                  widget.test.registeredAt.toString()),
                              _buildInfoRow('Edad cronológica',
                                  widget.test.cronologicalAge),
                              _buildInfoRow('Edad evolutiva',
                                  widget.test.evolutionaryAge),
                            ],
                          ),
                        ),
                        TestProgressIndicatorWidget(
                            progress: widget.test.progress),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
