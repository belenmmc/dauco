import 'package:dauco/data/repositories/minor_repository_interface.dart';
import 'package:dauco/data/services/minor_service.dart';
import 'package:dauco/domain/entities/minor.entity.dart';

class MinorRepository implements MinorRepositoryInterface {
  MinorService minorService = MinorService();

  MinorRepository({required this.minorService});

  @override
  Future<List<Minor>> getAllMinors(int page) {
    return minorService.getMinorsPage(page);
  }
}
