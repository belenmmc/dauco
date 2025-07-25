import 'package:dauco/data/repositories/implementation/test_repository.dart';
import 'package:dauco/domain/entities/test.entity.dart';

class GetAllTestsUseCase {
  final TestRepository testRepository;

  GetAllTestsUseCase({required this.testRepository});

  Future<List<Test>> execute(int minorId) async {
    return await testRepository.getAllTests(minorId);
  }
}
