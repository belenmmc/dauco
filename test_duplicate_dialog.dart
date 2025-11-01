import 'package:flutter/material.dart';
import 'package:dauco/presentation/widgets/duplicate_conflict_dialog.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Test Duplicate Dialog')),
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () async {
                // Test dialog with sample data
                final existingRecord = {
                  'menor_id': '123',
                  'nombre': 'Juan',
                  'apellidos': 'Pérez',
                  'fecha_nacimiento': '2010-01-15',
                  'sexo': 'M',
                  'responsable_id': '456'
                };

                final newRecord = {
                  'menor_id': '123',
                  'nombre': 'Juan Carlos',
                  'apellidos': 'Pérez García',
                  'fecha_nacimiento': '2010-01-15',
                  'sexo': 'M',
                  'responsable_id': '789'
                };

                final result = await showDialog<ConflictResolution>(
                  context: context,
                  builder: (context) => DuplicateConflictDialog(
                    primaryKey: 'menor_id',
                    // required parameters added:
                    recordType: 'Menor',
                    primaryKeyValue: existingRecord['menor_id'],
                    existingRecord: existingRecord,
                    newRecord: newRecord,
                  ),
                );

                print('User selected: $result');
              },
              child: Text('Test Duplicate Dialog'),
            );
          },
        ),
      ),
    ),
  ));
}
