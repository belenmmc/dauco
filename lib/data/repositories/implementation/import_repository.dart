import 'package:dauco/data/repositories/import_repository_interface.dart';
import 'package:dauco/data/services/import_service.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:excel/excel.dart';

class ImportRepository implements ImportRepositoryInterface {
  ImportService importService = ImportService();

  ImportRepository({required this.importService});

  @override
  Future<Excel?> loadFile() {
    return importService.loadFile();
  }

  @override
  Future<List<ImportedUser>> getUsers(file, int page, int pageSize) async {
    return await importService.getUsers(file, page: page, pageSize: pageSize);
  }

  @override
  Future<List<Minor>> getMinors(file, int page, int pageSize) {
    return importService.getMinors(file, page: page, pageSize: pageSize);
  }
}
