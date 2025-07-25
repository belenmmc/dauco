import 'package:dauco/data/repositories/test_repository_interface.dart';
import 'package:dauco/data/services/test_service.dart';
import 'package:dauco/domain/entities/test.entity.dart';

class TestRepository implements TestRepositoryInterface {
  TestService testService = TestService();

  TestRepository({required this.testService});

  @override
  Future<List<Test>> getAllTests(int minorId) {
    return testService.getTests(minorId);
  }
}
