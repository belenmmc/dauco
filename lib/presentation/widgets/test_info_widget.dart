import 'package:dauco/domain/entities/test.entity.dart';
import 'package:flutter/material.dart';

class TestInfoWidget extends StatelessWidget {
  final Test test;

  const TestInfoWidget({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Test ${test.testId}'),
          _buildInfoRow('Id del menor', test.testId.toString()),
          _buildInfoRow('Fecha de registro', test.registeredAt.toString()),
          _buildInfoRow('Edad cronológica', test.cronologicalAge),
          _buildInfoRow('Edad evolutiva', test.evolutiveAge),
          _buildInfoRow('Test M-CHAT', test.mChatTest),
          _buildInfoRow('Progreso', test.progress),
          _buildInfoRow('Áreas activas', test.activeAreas),
          _buildInfoRow('Tipo de profesional', test.proffesionalType),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
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
