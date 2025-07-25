import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:excel/excel.dart';

abstract class ImportRepositoryInterface {
  Future<Excel?> pickFile();

  Future<void> loadFile(Excel file, Function(double) onProgress);

  Future<List<ImportedUser>> getUsers(file, int page, int pageSize);

  Future<List<Test>> getTests(file, int minorId);

  Future<List<Item>> getItems(file, int testId);
}
