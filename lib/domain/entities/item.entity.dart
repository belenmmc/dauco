class Item {
  final int responseId;
  final int itemId;
  final String item;
  final int testId;
  final String area;
  final String question;
  final String answer;

  Item({
    required this.responseId,
    required this.itemId,
    required this.item,
    required this.testId,
    required this.area,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'respuesta_id': responseId,
      'item_id': itemId,
      'num_item_id': item,
      'test_id': testId,
      'area': area,
      'pregunta': question,
      'respuesta': answer,
    };
  }
}
