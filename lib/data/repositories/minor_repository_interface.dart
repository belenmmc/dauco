import 'package:dauco/domain/entities/minor.entity.dart';

abstract class MinorRepositoryInterface {
  Future<List<Minor>> getAllMinors(int page);
}
