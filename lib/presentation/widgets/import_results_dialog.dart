import 'package:flutter/material.dart';

class ImportResultsDialog extends StatelessWidget {
  final Map<String, Map<String, int>> importResults;

  const ImportResultsDialog({
    super.key,
    required this.importResults,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 248, 251, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.upload_file,
            color: Color.fromARGB(255, 97, 135, 174),
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            'Resultados de la Importación',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 43, 45, 66),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'La importación se ha completado exitosamente. Aquí tienes un resumen:',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 43, 45, 66),
              ),
            ),
            const SizedBox(height: 20),
            ...importResults.entries
                .map((entry) => _buildCategorySection(entry.key, entry.value)),
            const SizedBox(height: 16),
            _buildTotalSummary(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: const Color.fromARGB(255, 97, 135, 174),
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'Cerrar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(String category, Map<String, int> stats) {
    String categoryName = _getCategoryDisplayName(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromARGB(255, 213, 222, 233),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 43, 45, 66),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                  'Insertados', stats['inserted'] ?? 0, Colors.green),
              _buildStatItem(
                  'Actualizados', stats['updated'] ?? 0, Colors.orange),
              _buildStatItem('Omitidos', stats['skipped'] ?? 0, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 98, 100, 116),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSummary() {
    int totalInserted = 0;
    int totalUpdated = 0;
    int totalSkipped = 0;

    for (var stats in importResults.values) {
      totalInserted += stats['inserted'] ?? 0;
      totalUpdated += stats['updated'] ?? 0;
      totalSkipped += stats['skipped'] ?? 0;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 97, 135, 174).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen Total',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 43, 45, 66),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Total Insertados', totalInserted, Colors.green),
              _buildStatItem('Total Actualizados', totalUpdated, Colors.orange),
              _buildStatItem('Total Omitidos', totalSkipped, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'users':
        return 'Usuarios';
      case 'minors':
        return 'Menores';
      case 'tests':
        return 'Tests';
      case 'items':
        return 'Items';
      default:
        return category.toUpperCase();
    }
  }
}
