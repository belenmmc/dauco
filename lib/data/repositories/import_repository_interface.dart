import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

abstract class ImportRepositoryInterface {
  Future<Excel?> pickFile();

  Future<Map<String, Map<String, int>>> loadFile(
      Excel file, Function(double) onProgress, BuildContext context);

  Future<List<ImportedUser>> getUsers(file, int page, int pageSize);

  Future<List<Test>> getTests(file, int minorId);

  Future<List<Item>> getItems(file, int testId);
}
