import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:excel/excel.dart';

class LoadFileUseCase {
  final ImportRepository importRepository;

  LoadFileUseCase({required this.importRepository});

  Future<Excel?> execute() async {
    return await importRepository.loadFile();
  }
}
