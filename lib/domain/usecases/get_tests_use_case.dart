import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/domain/entities/test.entity.dart';

class GetTestsUseCase {
  final ImportRepository importRepository;

  GetTestsUseCase({required this.importRepository});

  Future<List<Test>> execute(file, int minorId) async {
    return await importRepository.getTests(file, minorId);
  }
}
