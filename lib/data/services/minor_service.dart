import 'package:dauco/data/services/mappers/minor_mapper.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MinorService {
  Future<List<Minor>> getMinorsPage(int page) async {
    int limit = 20;

    final from = page * limit;
    final to = from + limit - 1;
    final Future<List<Minor>> res;

    final session = Supabase.instance.client.auth.currentSession;

    final managerId = await Supabase.instance.client
        .from('usuarios')
        .select('manager_id')
        .eq('email', session!.user.email.toString())
        .single()
        .then((response) => response['manager_id'].toString());

    if (managerId == "0") {
      res = Supabase.instance.client
          .from("Menores")
          .select()
          .range(from, to)
          .order('menor_id', ascending: true)
          .then((response) {
        return (response.toList())
            .map((item) => MinorMapper.toDomain(item))
            .toList();
      });
    } else {
      res = Supabase.instance.client
          .from("Menores")
          .select()
          .eq('responsable_id', managerId)
          .order('menor_id', ascending: true)
          .then((response) {
        return (response.toList())
            .map((item) => MinorMapper.toDomain(item))
            .toList();
      });
    }

    return res;
  }

  /// Get ALL minors for export purposes (no pagination)
  Future<List<Minor>> getAllMinorsForExport() async {
    final session = Supabase.instance.client.auth.currentSession;

    final managerId = await Supabase.instance.client
        .from('usuarios')
        .select('manager_id')
        .eq('email', session!.user.email.toString())
        .single()
        .then((response) => response['manager_id'].toString());

    if (managerId == "0") {
      // Admin: Get ALL minors without pagination
      return Supabase.instance.client
          .from("Menores")
          .select()
          .order('menor_id', ascending: true)
          .then((response) {
        return (response.toList())
            .map((item) => MinorMapper.toDomain(item))
            .toList();
      });
    } else {
      // Manager: Get all minors they manage (same as paginated version)
      return Supabase.instance.client
          .from("Menores")
          .select()
          .eq('responsable_id', managerId)
          .order('menor_id', ascending: true)
          .then((response) {
        return (response.toList())
            .map((item) => MinorMapper.toDomain(item))
            .toList();
      });
    }
  }

  Future<void> updateMinor(Minor minor) async {
    await Supabase.instance.client
        .from('Menores')
        .update(MinorMapper.toJson(minor))
        .eq('menor_id', minor.minorId);
  }

  Future<void> deleteMinor(String minorId) async {
    await Supabase.instance.client
        .from('Menores')
        .delete()
        .eq('menor_id', minorId);
  }
}
