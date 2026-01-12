import 'package:dauco/data/services/mappers/minor_mapper.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MinorService {
  Future<List<Minor>> getMinorsPage(
    int page, {
    String? filterManagerId,
    String? filterName,
    String? filterSex,
    String? filterZipCode,
    DateTime? filterBirthdateFrom,
    DateTime? filterBirthdateTo,
  }) async {
    int limit = 20;

    final from = page * limit;
    final to = from + limit - 1;

    final session = Supabase.instance.client.auth.currentSession;

    final managerId = await Supabase.instance.client
        .from('usuarios')
        .select('manager_id')
        .eq('email', session!.user.email.toString())
        .single()
        .then((response) => response['manager_id'].toString());

    var query = Supabase.instance.client.from("Menores").select();

    // Apply manager filter based on user role
    if (managerId == "0") {
      // Admin: can filter by specific manager if provided
      if (filterManagerId != null && filterManagerId.isNotEmpty) {
        query = query.eq('responsable_id', filterManagerId);
      }
    } else {
      // Manager: always filter by their own ID
      query = query.eq('responsable_id', managerId);
    }

    // Apply additional filters
    if (filterName != null && filterName.isNotEmpty) {
      // menor_id is bigint, convert search to exact number match
      final numericId = int.tryParse(filterName);
      if (numericId != null) {
        query = query.eq('menor_id', numericId);
      }
    }

    if (filterSex != null && filterSex.isNotEmpty) {
      String sexValue = filterSex.toUpperCase();
      if (sexValue == 'M') {
        query = query.or('sexo.eq.M,sexo.eq.MASCULINO,sexo.eq.MALE');
      } else if (sexValue == 'F') {
        query = query.or('sexo.eq.F,sexo.eq.FEMENINO,sexo.eq.FEMALE');
      }
    }

    if (filterZipCode != null && filterZipCode.isNotEmpty) {
      // cp is bigint, use eq for exact match
      query = query.eq('cp', int.tryParse(filterZipCode) ?? 0);
    }

    if (filterBirthdateFrom != null) {
      query =
          query.gte('fecha_nacimiento', filterBirthdateFrom.toIso8601String());
    }

    if (filterBirthdateTo != null) {
      query =
          query.lte('fecha_nacimiento', filterBirthdateTo.toIso8601String());
    }

    // Apply pagination only if no specific manager filter
    final res =
        managerId == "0" && (filterManagerId == null || filterManagerId.isEmpty)
            ? query
                .range(from, to)
                .order('menor_id', ascending: true)
                .then((response) {
                return (response.toList())
                    .map((item) => MinorMapper.toDomain(item))
                    .toList();
              })
            : query.order('menor_id', ascending: true).then((response) {
                return (response.toList())
                    .map((item) => MinorMapper.toDomain(item))
                    .toList();
              });

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
