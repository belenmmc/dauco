import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/domain/entities/minor.entity.dart';

class GetMinorsUseCase {
  final ImportRepository importRepository;

  GetMinorsUseCase({required this.importRepository});

  Future<List<Minor>> execute(file, {int page = 1, int pageSize = 10}) async {
    return await importRepository.getMinors(file, page, pageSize);
  }
}
