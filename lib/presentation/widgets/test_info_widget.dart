import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/presentation/widgets/test_progress_indicator_widget.dart';
import 'package:flutter/material.dart';

class TestInfoWidget extends StatelessWidget {
  final Test test;
  final List<Item> items;

  const TestInfoWidget({super.key, required this.test, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Color.fromARGB(255, 206, 219, 237),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTestHeader(),
            SizedBox(height: 16),
            _buildTestItems(items),
          ],
        ),
      ),
    );
  }

  Widget _buildTestHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 8),
        Text(
          'Test ${test.testId}',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderItem('Fecha de alta: ',
                                test.registeredAt.toString()),
                            SizedBox(height: 8),
                            _buildHeaderItem(
                                'Edad cronológica: ', test.cronologicalAge),
                            SizedBox(height: 8),
                            _buildHeaderItem(
                                'Edad evolutiva: ', test.evolutionaryAge),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildHeaderItem(
                                'Test M-CHAT: ', test.mChatTest.toString()),
                            SizedBox(height: 8),
                            _buildHeaderItem(
                                'Tipo profesional: ', test.professionalType),
                            SizedBox(height: 8),
                            _buildHeaderItem(
                                'Áreas activas: ', test.activeAreas.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        TestProgressIndicatorWidget(progress: test.progress),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTestItems(List<Item> items) {
    Map<String, List<Item>> groupedItems = {};

    for (var item in items) {
      groupedItems.putIfAbsent(item.area, () => []).add(item);
    }

    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: items.isEmpty
              ? Center(
                  child: Text(
                    'No hay items disponibles',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: groupedItems.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Column(
                            children: entry.value
                                .map((item) => _buildListItem(item))
                                .toList(),
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildListItem(Item item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  item.item,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 97, 135, 174)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.question,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 150,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    item.answer,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 1, color: const Color.fromARGB(255, 206, 206, 237)),
      ],
    );
  }

  Widget _buildHeaderItem(String title, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }
}
