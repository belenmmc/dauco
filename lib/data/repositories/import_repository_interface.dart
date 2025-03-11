import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:excel/excel.dart';

abstract class ImportRepositoryInterface {
  Future<Excel?> loadFile();

  Future<List<ImportedUser>> getUsers(file, int page, int pageSize);

  Future<List<Minor>> getMinors(file, int page, int pageSize);
}
