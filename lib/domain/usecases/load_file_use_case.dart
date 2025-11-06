import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

class LoadFileUseCase {
  final ImportRepository importRepository;

  LoadFileUseCase({required this.importRepository});

  Future<Map<String, Map<String, int>>> execute(
      Excel file, Function(double) onProgress, BuildContext context) async {
    return await importRepository.loadFile(file, onProgress, context);
  }
}
