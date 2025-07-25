import 'package:dauco/domain/entities/item.entity.dart';

class ItemMapper {
  static Item toDomain(Map<String, dynamic> item) {
    return Item(
      responseId: item['respuesta_id'] as int,
      itemId: item['item_id'] as int,
      item: item['num_item_id'] as String,
      testId: item['test_id'] as int,
      area: item['area'] as String,
      question: item['pregunta'] as String,
      answer: item['respuesta'] as String,
    );
  }

  static Map<String, dynamic> toJson(Item item) {
    return {
      'respuesta_id': item.responseId,
      'item_id': item.itemId,
      'num_item_id': item.item,
      'test_id': item.testId,
      'area': item.area,
      'pregunta': item.question,
      'respuesta': item.answer,
    };
  }
}
