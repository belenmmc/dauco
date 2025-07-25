import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:excel/excel.dart';

class LoadFileUseCase {
  final ImportRepository importRepository;

  LoadFileUseCase({required this.importRepository});

  Future<void> execute(Excel file, Function(double) onProgress) async {
    return await importRepository.loadFile(file, onProgress);
  }
}
