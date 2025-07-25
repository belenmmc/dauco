import 'package:dauco/data/repositories/implementation/item_repository.dart';
import 'package:dauco/domain/entities/item.entity.dart';

class GetAllItemsUseCase {
  final ItemRepository itemRepository;

  GetAllItemsUseCase({required this.itemRepository});

  Future<List<Item>> execute(int testId) async {
    return await itemRepository.getAllItems(testId);
  }
}
