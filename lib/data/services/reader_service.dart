import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReaderService {
  Future<void> readExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      if (fileBytes == null) {
        File file = File(result.files.first.path!);
        fileBytes = await file.readAsBytes();
      }

      var excel = Excel.decodeBytes(fileBytes);

      for (var table in excel.tables.keys) {
        print('Processing table: $table');

        for (var row in excel.tables[table]!.rows.skip(1)) {
          if (row.isEmpty || row.every((cell) => cell == null)) continue;

          // Extract data
          var column1 = row[0]?.value.toString() ?? 'NULL';
          var column2 = row[1]?.value.toString() ?? 'NULL';

          // Insert into Supabase
          await Supabase.instance.client.from(table).insert({
            'column1': column1,
            'column2': column2,
          });

          print("Inserted into $table: $column1, $column2");
        }
      }

      print("Data inserted successfully.");
    } else {
      print('User canceled file picker');
    }
  }
}
