import 'package:dauco/domain/entities/item.entity.dart';

abstract class ItemRepositoryInterface {
  Future<List<Item>> getAllItems(int testId);
}
