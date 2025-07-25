import 'package:dauco/data/repositories/import_repository_interface.dart';
import 'package:dauco/data/services/import_service.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:excel/excel.dart';

class ImportRepository implements ImportRepositoryInterface {
  ImportService importService = ImportService();

  ImportRepository({required this.importService});

  @override
  Future<Excel?> pickFile() {
    return importService.pickFile();
  }

  @override
  Future<void> loadFile(Excel file, Function(double p1) onProgress) {
    return importService.loadFile(file, onProgress);
  }

  @override
  Future<List<Item>> getItems(file, int testId) {
    // TODO: implement getItems
    throw UnimplementedError();
  }

  @override
  Future<List<Test>> getTests(file, int minorId) {
    // TODO: implement getTests
    throw UnimplementedError();
  }

  @override
  Future<List<ImportedUser>> getUsers(file, int page, int pageSize) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}
