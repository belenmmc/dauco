import 'package:dauco/domain/entities/test.entity.dart';

abstract class TestRepositoryInterface {
  Future<List<Test>> getAllTests(int minorId);
}
