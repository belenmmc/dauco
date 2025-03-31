import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/domain/entities/item.entity.dart';

class GetItemsUseCase {
  final ImportRepository importRepository;

  GetItemsUseCase({required this.importRepository});

  Future<List<Item>> execute(file, int testId) async {
    return await importRepository.getItems(file, testId);
  }
}
