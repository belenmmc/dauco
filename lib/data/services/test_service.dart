import 'package:dauco/data/services/mappers/test_mapper.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestService {
  Future<List<Test>> getTests(int minorId) {
    final res = Supabase.instance.client
        .from("Tests")
        .select()
        .eq('menor_id', minorId)
        .order('test_id', ascending: true)
        .then((response) {
      return (response.toList())
          .map((item) => TestMapper.toDomain(item))
          .toList();
    });
    return res;
  }
}
