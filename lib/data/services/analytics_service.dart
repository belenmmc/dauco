import 'package:dauco/data/services/mappers/minor_mapper.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsService {
  final _supabase = Supabase.instance.client;

  // Existing methods...
  Future<Map<String, int>> getGenderDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('sexo');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String gender = row['sexo'] ?? 'No especificado';
        distribution[gender] = (distribution[gender] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting gender distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getAgeRangeDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('rango_edad');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String ageRange = row['rango_edad'] ?? 'No especificado';
        distribution[ageRange] = (distribution[ageRange] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting age range distribution: $e');
      return {};
    }
  }

  Future<Map<String, double>> getTestCompletionStats() async {
    try {
      final response =
          await _supabase.from('Menores').select('num_tests, test_completados');

      int totalTests = 0;
      int completedTests = 0;

      for (final row in response) {
        totalTests += row['num_tests'] as int? ?? 0;
        completedTests += row['test_completados'] as int? ?? 0;
      }

      final pending = totalTests - completedTests;
      final completionRate =
          totalTests > 0 ? (completedTests / totalTests) * 100 : 0.0;

      return {
        'completed': completedTests.toDouble(),
        'pending': pending.toDouble(),
        'completion_rate': completionRate,
      };
    } catch (e) {
      print('Error getting test completion stats: $e');
      return {};
    }
  }

  Future<Map<String, int>> getProfessionalTypeDistribution() async {
    try {
      final response = await Supabase.instance.client
          .from('usuarios')
          .select('role')
          .neq('role', 'admin');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String role = row['role'] ?? 'No especificado';
        distribution[role] = (distribution[role] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting professional type distribution: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getMonthlyRegistrations() async {
    try {
      final response = await _supabase.from('Menores').select('alta');

      final Map<String, int> monthlyCount = {};

      for (final row in response) {
        final String dateStr = row['alta'];
        final DateTime date = DateTime.parse(dateStr);
        final String monthKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}';
        monthlyCount[monthKey] = (monthlyCount[monthKey] ?? 0) + 1;
      }

      final List<Map<String, dynamic>> result = monthlyCount.entries
          .map((entry) => {
                'month': entry.key,
                'count': entry.value,
              })
          .toList();

      result.sort((a, b) => a['month'].compareTo(b['month']));
      return result;
    } catch (e) {
      print('Error getting monthly registrations: $e');
      return [];
    }
  }

  Future<Map<String, int>> getMChatDistribution() async {
    try {
      final response = await _supabase.from('Tests').select('test_mchat');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final bool hasMChat = row['test_mchat'] as bool? ?? false;
        final String category = hasMChat ? 'Con M-CHAT' : 'Sin M-CHAT';
        distribution[category] = (distribution[category] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting M-CHAT distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getGeographicalDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('cp');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String zipCode = row['cp']?.toString() ?? 'No especificado';
        distribution[zipCode] = (distribution[zipCode] ?? 0) + 1;
      }

      // Return only top 10 zip codes for better visualization
      final sortedEntries = distribution.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final Map<String, int> topZipCodes = {};
      for (int i = 0; i < 10 && i < sortedEntries.length; i++) {
        topZipCodes[sortedEntries[i].key] = sortedEntries[i].value;
      }

      return topZipCodes;
    } catch (e) {
      print('Error getting geographical distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getTestAreasDistribution() async {
    try {
      final response = await _supabase.from('Items').select('area');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String area = row['area'] ?? 'No especificado';
        distribution[area] = (distribution[area] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting test areas distribution: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getUsersActivity() async {
    final response = await _supabase
        .rpc('get_user_activity')
        .then((data) => List<Map<String, dynamic>>.from(data))
        .catchError((_) async {
      // Fallback: manual aggregation
      final users = await _supabase.from('usuarios').select('manager_id, name');
      final minors = await _supabase.from('Menores').select('responsable_id');

      final Map<int, int> userMinorCount = {};
      for (var minor in minors) {
        final managerId = minor['responsable_id'] as int;
        userMinorCount[managerId] = (userMinorCount[managerId] ?? 0) + 1;
      }

      final List<Map<String, dynamic>> result = [];
      for (var user in users) {
        final managerId = user['manager_id'] as int;
        result.add({
          'user_name': user['name'],
          'minor_count': userMinorCount[managerId] ?? 0,
        });
      }

      return result;
    });
    return response;
  }

  // NEW CHARTS - More interesting data visualizations

  Future<Map<String, int>> getBirthTypeDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('tipo_parto');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String birthType = row['tipo_parto'] ?? 'No especificado';
        distribution[birthType] = (distribution[birthType] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting birth type distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getGestationWeeksDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('semana_gestacion');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final int weeks = row['semana_gestacion'] as int? ?? 0;
        String category;
        if (weeks < 32) {
          category = 'Muy prematuro (<32 sem)';
        } else if (weeks < 37) {
          category = 'Prematuro (32-36 sem)';
        } else if (weeks <= 42) {
          category = 'A término (37-42 sem)';
        } else {
          category = 'Post-término (>42 sem)';
        }
        distribution[category] = (distribution[category] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting gestation weeks distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getParentsCivilStatusDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('estado_civil_padres');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String status = row['estado_civil_padres'] ?? 'No especificado';
        distribution[status] = (distribution[status] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting parents civil status distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getSocioeconomicDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('situacion_socioeconomica');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String situation =
            row['situacion_socioeconomica'] ?? 'No especificado';
        distribution[situation] = (distribution[situation] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting socioeconomic distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getSchoolingLevelDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('nivel_escolarizacion');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String level = row['nivel_escolarizacion'] ?? 'No especificado';
        distribution[level] = (distribution[level] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting schooling level distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getEvaluationReasonDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('motivo_valoracion');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String reason = row['motivo_valoracion'] ?? 'No especificado';
        distribution[reason] = (distribution[reason] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting evaluation reason distribution: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getParentsAgeDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('edad_padre, edad_madre');

      final List<Map<String, dynamic>> ageData = [];

      for (final row in response) {
        final int fatherAge = row['edad_padre'] as int? ?? 0;
        final int motherAge = row['edad_madre'] as int? ?? 0;

        if (fatherAge > 0) {
          ageData.add({
            'parent': 'Padre',
            'age': fatherAge,
          });
        }
        if (motherAge > 0) {
          ageData.add({
            'parent': 'Madre',
            'age': motherAge,
          });
        }
      }

      return ageData;
    } catch (e) {
      print('Error getting parents age distribution: $e');
      return [];
    }
  }

  Future<Map<String, int>> getSiblingsDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('hermanos');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final int siblings = row['hermanos'] as int? ?? 0;
        String category;
        if (siblings == 0) {
          category = 'Hijo único';
        } else if (siblings == 1) {
          category = '1 hermano';
        } else if (siblings <= 3) {
          category = '2-3 hermanos';
        } else {
          category = '4+ hermanos';
        }
        distribution[category] = (distribution[category] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting siblings distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getBirthWeightDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('peso_nacimiento');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final int weight = row['peso_nacimiento'] as int? ?? 0;
        String category;
        if (weight < 1500) {
          category = 'Muy bajo peso (<1500g)';
        } else if (weight < 2500) {
          category = 'Bajo peso (1500-2499g)';
        } else if (weight <= 4000) {
          category = 'Peso normal (2500-4000g)';
        } else {
          category = 'Alto peso (>4000g)';
        }
        distribution[category] = (distribution[category] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting birth weight distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getFamilyMembersDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('familiares_domicilio');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final int members = row['familiares_domicilio'] as int? ?? 0;
        String category;
        if (members <= 2) {
          category = '1-2 miembros';
        } else if (members <= 4) {
          category = '3-4 miembros';
        } else if (members <= 6) {
          category = '5-6 miembros';
        } else {
          category = '7+ miembros';
        }
        distribution[category] = (distribution[category] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting family members distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getApgarScoreDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('test_apgar');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final int score = row['test_apgar'] as int? ?? 0;
        String category;
        if (score <= 3) {
          category = 'Crítico (0-3)';
        } else if (score <= 6) {
          category = 'Moderado (4-6)';
        } else if (score <= 10) {
          category = 'Normal (7-10)';
        } else {
          category = 'No registrado';
        }
        distribution[category] = (distribution[category] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting APGAR score distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getFatherJobDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('trabajo_padre');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String job = row['trabajo_padre'] ?? '';
        final String jobLabel =
            (job.isEmpty || job == '0') ? 'No informado' : job;
        distribution[jobLabel] = (distribution[jobLabel] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting father job distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getMotherJobDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('trabajo_madre');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String job = row['trabajo_madre'] ?? '';
        final String jobLabel =
            (job.isEmpty || job == '0') ? 'No informado' : job;
        distribution[jobLabel] = (distribution[jobLabel] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting mother job distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getFatherStudiesDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('estudios_padre');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String studies = row['estudios_padre'] ?? '';
        final String studiesLabel =
            (studies.isEmpty || studies == '0') ? 'No informado' : studies;
        distribution[studiesLabel] = (distribution[studiesLabel] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting father studies distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getMotherStudiesDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('estudios_madre');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final String studies = row['estudios_madre'] ?? '';
        final String studiesLabel =
            (studies.isEmpty || studies == '0') ? 'No informado' : studies;
        distribution[studiesLabel] = (distribution[studiesLabel] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting mother studies distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getAdoptionDistribution() async {
    try {
      final response = await _supabase.from('Menores').select('adopcion');

      final Map<String, int> distribution = {};
      for (final row in response) {
        final int adoptionValue = row['adopcion'] as int? ?? 0;
        final String category = adoptionValue == 1 ? 'Adoptado' : 'No adoptado';
        distribution[category] = (distribution[category] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting adoption distribution: $e');
      return {};
    }
  }

  Future<Map<String, int>> getDiagnosisDistribution() async {
    try {
      final response =
          await _supabase.from('Menores').select('motivo_valoracion');

      final Map<String, int> distribution = {};

      for (final row in response) {
        final String reason = row['motivo_valoracion'] ?? 'No informado';

        // Categorize based on evaluation reason
        String category;
        if (reason == 'Diagnóstico') {
          category = 'Diagnosticado';
        } else if (reason == 'Sospecha de retraso evolutivo') {
          category = 'Sospecha de retraso';
        } else if (reason == 'Niño sano') {
          category = 'Niño sano';
        } else if (reason == 'Investigación-Validación') {
          category = 'Investigación';
        } else if (reason == 'Versión de prueba') {
          category = 'Prueba';
        } else if (reason == 'Otros') {
          category = 'Otros';
        } else {
          category = 'No informado';
        }

        distribution[category] = (distribution[category] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      print('Error getting diagnosis distribution: $e');
      return {};
    }
  }

  Future<List<Minor>> getFilteredMinors(
      String filterType, String filterValue) async {
    try {
      print('🔍 ANALYTICS SERVICE: Filtering by $filterType = $filterValue');

      // Get current user's session and role
      final session = _supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No hay sesión activa');
      }

      // Get current user's role and manager_id
      final userData = await _supabase
          .from('usuarios')
          .select('role, manager_id')
          .eq('email', session.user.email.toString())
          .single();

      final userRole = userData['role'] as String;
      final userManagerId = userData['manager_id'] as int;

      PostgrestFilterBuilder query = _supabase.from('Menores').select('*');

      // Apply role-based filtering first
      if (userRole == 'manager') {
        // Managers can only see minors they manage
        query = query.eq('responsable_id', userManagerId);
      }
      // Admins can see all minors (no additional filter needed)

      switch (filterType) {
        case 'gender':
          query = query.eq('sexo', filterValue);
          break;
        case 'education':
          query = query.eq('nivel_escolarizacion', filterValue);
          break;
        case 'geographical':
          // Use ilike for partial matching, just like the visual search bar
          query = query.ilike('cp', '%$filterValue%');
          print(
              '🔍 ANALYTICS SERVICE: Using geographical filter: cp ILIKE %$filterValue%');
          break;
        case 'test_status':
          // Handle test status filtering
          if (filterValue == 'Completados') {
            query = query.gt('test_completados', 0);
          } else if (filterValue == 'Pendientes') {
            query = query.eq('test_completados', 0);
          }
          break;
        case 'father_profession':
          query = query.eq('trabajo_padre', filterValue);
          break;
        case 'mother_profession':
          query = query.eq('trabajo_madre', filterValue);
          break;
        case 'father_education':
          query = query.eq('estudios_padre', filterValue);
          break;
        case 'mother_education':
          query = query.eq('estudios_madre', filterValue);
          break;
        case 'adoption_status':
          if (filterValue == 'Adoptado') {
            query = query.eq('adopcion', 1);
          } else {
            query = query.eq('adopcion', 0);
          }
          break;
        case 'birth_type':
          query = query.eq('tipo_parto', filterValue);
          break;
        case 'evaluation':
          query = query.eq('motivo_valoracion', filterValue);
          break;
        case 'diagnosis':
          // Handle diagnosis categories
          String motivo = '';
          switch (filterValue) {
            case 'Diagnosticado':
              motivo = 'Diagnóstico';
              break;
            case 'Sospecha de retraso':
              motivo = 'Sospecha de retraso evolutivo';
              break;
            case 'Niño sano':
              motivo = 'Niño sano';
              break;
            case 'Investigación':
              motivo = 'Investigación-Validación';
              break;
            case 'Prueba':
              motivo = 'Versión de prueba';
              break;
            case 'Otros':
              motivo = 'Otros';
              break;
            default:
              motivo = 'No informado';
          }
          query = query.eq('motivo_valoracion', motivo);
          break;
        case 'gestation_weeks':
          query = query.eq('semana_gestacion', int.tryParse(filterValue) ?? 0);
          break;
        case 'birth_weight':
          // Handle birth weight ranges
          if (filterValue.contains('<')) {
            query = query.lt('peso_nacimiento', 1500);
          } else if (filterValue.contains('1500-2500')) {
            query =
                query.gte('peso_nacimiento', 1500).lt('peso_nacimiento', 2500);
          } else if (filterValue.contains('>')) {
            query = query.gte('peso_nacimiento', 2500);
          }
          break;
        case 'apgar_test':
          // Handle APGAR score ranges
          if (filterValue.contains('0-3')) {
            query = query.gte('test_apgar', 0).lte('test_apgar', 3);
          } else if (filterValue.contains('4-6')) {
            query = query.gte('test_apgar', 4).lte('test_apgar', 6);
          } else if (filterValue.contains('7-10')) {
            query = query.gte('test_apgar', 7).lte('test_apgar', 10);
          }
          break;
        case 'parents_civil_status':
          query = query.eq('estado_civil_padres', filterValue);
          break;
        case 'siblings':
          query = query.eq(
              'hermanos', int.tryParse(filterValue.split(' ')[0]) ?? 0);
          break;
        case 'family_members':
          // Handle family member ranges
          if (filterValue.contains('1-2')) {
            query = query
                .gte('familiares_domicilio', 1)
                .lte('familiares_domicilio', 2);
          } else if (filterValue.contains('3-4')) {
            query = query
                .gte('familiares_domicilio', 3)
                .lte('familiares_domicilio', 4);
          } else if (filterValue.contains('5+')) {
            query = query.gte('familiares_domicilio', 5);
          }
          break;
        case 'socioeconomic_situation':
          query = query.eq('situacion_socioeconomica', filterValue);
          break;
        case 'parent_age':
          // Handle parent age filtering with format "Padre:<25" or "Madre:35-44"
          final parts = filterValue.split(':');
          if (parts.length == 2) {
            final parentType = parts[0];
            final ageRange = parts[1];
            final column = parentType == 'Padre' ? 'edad_padre' : 'edad_madre';

            if (ageRange == '<25') {
              query = query.lt(column, 25);
            } else if (ageRange == '25-34') {
              query = query.gte(column, 25).lt(column, 35);
            } else if (ageRange == '35-44') {
              query = query.gte(column, 35).lt(column, 45);
            } else if (ageRange == '45+') {
              query = query.gte(column, 45);
            }
          }
          break;
        default:
          throw Exception('Filter type not supported: $filterType');
      }

      final response = await query;

      List<Minor> minors = [];
      for (final row in response) {
        minors.add(MinorMapper.toDomain(row));
      }

      print('🔍 ANALYTICS SERVICE: Query returned ${minors.length} minors');
      print(
          '🔍 FILTERED MINOR IDS: ${minors.map((m) => m.minorId).take(10).toList()}...');

      return minors;
    } catch (e) {
      print('Error getting filtered minors: $e');
      return [];
    }
  }
}
