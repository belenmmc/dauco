import 'package:dauco/data/services/mappers/item_mapper.dart';
import 'package:dauco/domain/entities/item.entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemService {
  Future<List<Item>> getItems(int testId) {
    final res = Supabase.instance.client
        .from("Items")
        .select()
        .eq('test_id', testId)
        .order('item_id', ascending: true)
        .then((response) {
      return (response.toList())
          .map((item) => ItemMapper.toDomain(item))
          .toList();
    });
    return res;
  }
}
