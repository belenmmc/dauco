import 'package:dauco/data/repositories/item_repository_interface.dart';
import 'package:dauco/data/services/item_service.dart';
import 'package:dauco/domain/entities/item.entity.dart';

class ItemRepository implements ItemRepositoryInterface {
  ItemService itemService = ItemService();

  ItemRepository({required this.itemService});

  @override
  Future<List<Item>> getAllItems(int testId) {
    return itemService.getItems(testId);
  }
}
