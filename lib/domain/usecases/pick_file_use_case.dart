import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:excel/excel.dart';

class PickFileUseCase {
  final ImportRepository importRepository;

  PickFileUseCase({required this.importRepository});

  Future<Excel?> execute() async {
    return await importRepository.pickFile();
  }
}
