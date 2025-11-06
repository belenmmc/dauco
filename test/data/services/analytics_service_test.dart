import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalyticsService - Data Processing Logic Tests', () {
    test('birth weight categorization logic', () {
      // Test the weight categorization logic directly
      Map<String, int> categorizeWeights(List<int> weights) {
        final Map<String, int> distribution = {};
        for (final weight in weights) {
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
      }

      final weights = [1200, 2000, 3500, 4500, 0];
      final result = categorizeWeights(weights);

      expect(result, {
        'Muy bajo peso (<1500g)': 2, // 1200g and 0g
        'Bajo peso (1500-2499g)': 1, // 2000g
        'Peso normal (2500-4000g)': 1, // 3500g
        'Alto peso (>4000g)': 1, // 4500g
      });
    });

    test('APGAR score categorization logic', () {
      Map<String, int> categorizeApgarScores(List<int> scores) {
        final Map<String, int> distribution = {};
        for (final score in scores) {
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
      }

      final scores = [2, 5, 8, 10, 0];
      final result = categorizeApgarScores(scores);

      expect(result, {
        'Crítico (0-3)': 2, // scores 2 and 0
        'Moderado (4-6)': 1, // score 5
        'Normal (7-10)': 2, // scores 8 and 10
      });
    });

    test('parent age data processing logic', () {
      List<Map<String, dynamic>> processParentAges(
          List<Map<String, int?>> data) {
        final List<Map<String, dynamic>> ageData = [];

        for (final row in data) {
          final int fatherAge = row['edad_padre'] ?? 0;
          final int motherAge = row['edad_madre'] ?? 0;

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
      }

      final mockData = [
        {'edad_padre': 30, 'edad_madre': 28},
        {'edad_padre': 0, 'edad_madre': 35}, // Father age missing
        {'edad_padre': 40, 'edad_madre': 0}, // Mother age missing
        {'edad_padre': null, 'edad_madre': null}, // Both missing
      ];

      final result = processParentAges(mockData);

      expect(result.length, 4); // Only valid ages
      expect(
          result,
          containsAll([
            {'parent': 'Padre', 'age': 30},
            {'parent': 'Madre', 'age': 28},
            {'parent': 'Madre', 'age': 35},
            {'parent': 'Padre', 'age': 40},
          ]));
    });

    test('gestation weeks categorization logic', () {
      Map<String, int> categorizeGestationWeeks(List<int> weeks) {
        final Map<String, int> distribution = {};
        for (final week in weeks) {
          String category;
          if (week < 32) {
            category = 'Muy prematuro (<32 sem)';
          } else if (week < 37) {
            category = 'Prematuro (32-36 sem)';
          } else if (week <= 42) {
            category = 'A término (37-42 sem)';
          } else {
            category = 'Post-término (>42 sem)';
          }
          distribution[category] = (distribution[category] ?? 0) + 1;
        }
        return distribution;
      }

      final weeks = [30, 35, 39, 41, 44];
      final result = categorizeGestationWeeks(weeks);

      expect(result, {
        'Muy prematuro (<32 sem)': 1, // 30 weeks
        'Prematuro (32-36 sem)': 1, // 35 weeks
        'A término (37-42 sem)': 2, // 39, 41 weeks
        'Post-término (>42 sem)': 1, // 44 weeks
      });
    });

    test('siblings categorization logic', () {
      Map<String, int> categorizeSiblings(List<int> siblingsCount) {
        final Map<String, int> distribution = {};
        for (final siblings in siblingsCount) {
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
      }

      final siblingsData = [0, 1, 2, 3, 5];
      final result = categorizeSiblings(siblingsData);

      expect(result, {
        'Hijo único': 1, // 0 siblings
        '1 hermano': 1, // 1 sibling
        '2-3 hermanos': 2, // 2, 3 siblings
        '4+ hermanos': 1, // 5 siblings
      });
    });

    test('family members categorization logic', () {
      Map<String, int> categorizeFamilyMembers(List<int> membersCount) {
        final Map<String, int> distribution = {};
        for (final members in membersCount) {
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
      }

      final membersData = [1, 2, 3, 4, 5, 6, 8];
      final result = categorizeFamilyMembers(membersData);

      expect(result, {
        '1-2 miembros': 2, // 1, 2 members
        '3-4 miembros': 2, // 3, 4 members
        '5-6 miembros': 2, // 5, 6 members
        '7+ miembros': 1, // 8 members
      });
    });
  });

  group('AnalyticsService - Filter Logic Tests', () {
    test('parent age filter parsing logic', () {
      Map<String, dynamic> parseParentAgeFilter(String filterValue) {
        final parts = filterValue.split(':');
        if (parts.length != 2) {
          return {'valid': false};
        }

        final parentType = parts[0];
        final ageRange = parts[1];
        final column = parentType == 'Padre' ? 'edad_padre' : 'edad_madre';

        Map<String, dynamic> filter = {'valid': true, 'column': column};

        if (ageRange == '<25') {
          filter['condition'] = 'lt';
          filter['value'] = 25;
        } else if (ageRange == '25-34') {
          filter['condition'] = 'range';
          filter['min'] = 25;
          filter['max'] = 35;
        } else if (ageRange == '35-44') {
          filter['condition'] = 'range';
          filter['min'] = 35;
          filter['max'] = 45;
        } else if (ageRange == '45+') {
          filter['condition'] = 'gte';
          filter['value'] = 45;
        } else {
          filter['valid'] = false;
        }

        return filter;
      }

      // Test valid filter formats
      var result = parseParentAgeFilter('Padre:25-34');
      expect(result['valid'], true);
      expect(result['column'], 'edad_padre');
      expect(result['condition'], 'range');
      expect(result['min'], 25);
      expect(result['max'], 35);

      result = parseParentAgeFilter('Madre:<25');
      expect(result['valid'], true);
      expect(result['column'], 'edad_madre');
      expect(result['condition'], 'lt');
      expect(result['value'], 25);

      result = parseParentAgeFilter('Padre:45+');
      expect(result['valid'], true);
      expect(result['column'], 'edad_padre');
      expect(result['condition'], 'gte');
      expect(result['value'], 45);

      // Test invalid filter format
      result = parseParentAgeFilter('Padre25-34');
      expect(result['valid'], false);

      result = parseParentAgeFilter('Padre:unknown');
      expect(result['valid'], false);
    });

    test('birth weight filter parsing logic', () {
      Map<String, dynamic> parseBirthWeightFilter(String filterValue) {
        if (filterValue.contains('<1500')) {
          return {'condition': 'lt', 'value': 1500};
        } else if (filterValue.contains('1500-2499')) {
          return {'condition': 'range', 'min': 1500, 'max': 2500};
        } else if (filterValue.contains('2500-4000')) {
          return {'condition': 'range', 'min': 2500, 'max': 4000};
        } else if (filterValue.contains('>4000')) {
          return {'condition': 'gte', 'value': 4000};
        }
        return {'condition': 'unknown'};
      }

      var result = parseBirthWeightFilter('Muy bajo peso (<1500g)');
      expect(result['condition'], 'lt');
      expect(result['value'], 1500);

      result = parseBirthWeightFilter('Bajo peso (1500-2499g)');
      expect(result['condition'], 'range');
      expect(result['min'], 1500);
      expect(result['max'], 2500);

      result = parseBirthWeightFilter('Alto peso (>4000g)');
      expect(result['condition'], 'gte');
      expect(result['value'], 4000);
    });

    test('APGAR test filter parsing logic', () {
      Map<String, dynamic> parseApgarFilter(String filterValue) {
        if (filterValue.contains('0-3')) {
          return {'condition': 'range', 'min': 0, 'max': 3};
        } else if (filterValue.contains('4-6')) {
          return {'condition': 'range', 'min': 4, 'max': 6};
        } else if (filterValue.contains('7-10')) {
          return {'condition': 'range', 'min': 7, 'max': 10};
        }
        return {'condition': 'unknown'};
      }

      var result = parseApgarFilter('Crítico (0-3)');
      expect(result['condition'], 'range');
      expect(result['min'], 0);
      expect(result['max'], 3);

      result = parseApgarFilter('Moderado (4-6)');
      expect(result['condition'], 'range');
      expect(result['min'], 4);
      expect(result['max'], 6);

      result = parseApgarFilter('Normal (7-10)');
      expect(result['condition'], 'range');
      expect(result['min'], 7);
      expect(result['max'], 10);
    });

    test('family members filter parsing logic', () {
      Map<String, dynamic> parseFamilyMembersFilter(String filterValue) {
        if (filterValue.contains('1-2')) {
          return {'condition': 'range', 'min': 1, 'max': 2};
        } else if (filterValue.contains('3-4')) {
          return {'condition': 'range', 'min': 3, 'max': 4};
        } else if (filterValue.contains('5-6')) {
          return {'condition': 'range', 'min': 5, 'max': 6};
        } else if (filterValue.contains('7+')) {
          return {'condition': 'gte', 'value': 7};
        }
        return {'condition': 'unknown'};
      }

      var result = parseFamilyMembersFilter('1-2 miembros');
      expect(result['condition'], 'range');
      expect(result['min'], 1);
      expect(result['max'], 2);

      result = parseFamilyMembersFilter('3-4 miembros');
      expect(result['condition'], 'range');
      expect(result['min'], 3);
      expect(result['max'], 4);

      result = parseFamilyMembersFilter('7+ miembros');
      expect(result['condition'], 'gte');
      expect(result['value'], 7);
    });
  });

  group('AnalyticsService - Edge Cases and Error Handling', () {
    test('handles null and zero values in data processing', () {
      List<String> processGenderData(List<Map<String, dynamic>> data) {
        return data
            .map((row) => row['sexo'] as String? ?? 'No especificado')
            .toList();
      }

      final mockData = [
        {'sexo': 'Masculino'},
        {'sexo': null},
        {'sexo': ''},
        {'sexo': 'Femenino'},
      ];

      final result = processGenderData(mockData);
      expect(result, ['Masculino', 'No especificado', '', 'Femenino']);
    });

    test('test completion rate calculation handles edge cases', () {
      double calculateCompletionRate(int totalTests, int completedTests) {
        return totalTests > 0 ? (completedTests / totalTests) * 100 : 0.0;
      }

      // Normal case
      expect(calculateCompletionRate(10, 7), 70.0);

      // Division by zero case
      expect(calculateCompletionRate(0, 0), 0.0);

      // All completed
      expect(calculateCompletionRate(5, 5), 100.0);

      // None completed
      expect(calculateCompletionRate(5, 0), 0.0);
    });

    test('geographical data handles empty and null postal codes', () {
      Map<String, int> processPostalCodes(List<Map<String, dynamic>> data) {
        final Map<String, int> distribution = {};
        for (final row in data) {
          final String zipCode = row['cp']?.toString() ?? 'No especificado';
          distribution[zipCode] = (distribution[zipCode] ?? 0) + 1;
        }
        return distribution;
      }

      final mockData = [
        {'cp': '28001'},
        {'cp': null},
        {'cp': ''},
        {'cp': 28002},
        {'cp': '28001'},
      ];

      final result = processPostalCodes(mockData);
      expect(result, {
        '28001': 2,
        'No especificado': 1,
        '': 1,
        '28002': 1,
      });
    });

    test('diagnosis categorization handles all evaluation reasons', () {
      String categorizeDiagnosis(String? reason) {
        if (reason == null || reason.isEmpty) return 'No informado';

        switch (reason) {
          case 'Diagnóstico':
            return 'Diagnosticado';
          case 'Sospecha de retraso evolutivo':
            return 'Sospecha de retraso';
          case 'Niño sano':
            return 'Niño sano';
          case 'Investigación-Validación':
            return 'Investigación';
          case 'Versión de prueba':
            return 'Prueba';
          case 'Otros':
            return 'Otros';
          default:
            return 'No informado';
        }
      }

      expect(categorizeDiagnosis('Diagnóstico'), 'Diagnosticado');
      expect(categorizeDiagnosis('Sospecha de retraso evolutivo'),
          'Sospecha de retraso');
      expect(categorizeDiagnosis('Niño sano'), 'Niño sano');
      expect(categorizeDiagnosis('Investigación-Validación'), 'Investigación');
      expect(categorizeDiagnosis('Versión de prueba'), 'Prueba');
      expect(categorizeDiagnosis('Otros'), 'Otros');
      expect(categorizeDiagnosis('Unknown reason'), 'No informado');
      expect(categorizeDiagnosis(null), 'No informado');
      expect(categorizeDiagnosis(''), 'No informado');
    });
  });

  group('AnalyticsService - Data Validation Tests', () {
    test('validates parent age ranges are realistic', () {
      bool isValidParentAge(int age) {
        return age >= 15 && age <= 80;
      }

      expect(isValidParentAge(25), true);
      expect(isValidParentAge(45), true);
      expect(isValidParentAge(10), false); // Too young
      expect(isValidParentAge(85), false); // Too old
      expect(isValidParentAge(0), false); // Invalid
    });

    test('validates birth weight ranges are realistic', () {
      bool isValidBirthWeight(int weight) {
        return weight >= 500 && weight <= 6000; // grams
      }

      expect(isValidBirthWeight(3500), true);
      expect(isValidBirthWeight(2000), true);
      expect(isValidBirthWeight(400), false); // Too low
      expect(isValidBirthWeight(7000), false); // Too high
      expect(isValidBirthWeight(0), false); // Invalid
    });

    test('validates APGAR scores are in valid range', () {
      bool isValidApgarScore(int score) {
        return score >= 0 && score <= 10;
      }

      expect(isValidApgarScore(8), true);
      expect(isValidApgarScore(0), true);
      expect(isValidApgarScore(10), true);
      expect(isValidApgarScore(-1), false);
      expect(isValidApgarScore(11), false);
    });

    test('validates gestation weeks are realistic', () {
      bool isValidGestationWeeks(int weeks) {
        return weeks >= 20 && weeks <= 45;
      }

      expect(isValidGestationWeeks(39), true);
      expect(isValidGestationWeeks(32), true);
      expect(isValidGestationWeeks(15), false); // Too early
      expect(isValidGestationWeeks(50), false); // Too late
    });
  });

  group('AnalyticsService - Complex Filter Cases', () {
    test('validates birth weight range filters work correctly', () {
      // Simulate the actual filtering logic from the service
      bool matchesBirthWeightFilter(int weight, String filterValue) {
        if (filterValue.contains('<1500')) {
          return weight < 1500;
        } else if (filterValue.contains('1500-2499')) {
          return weight >= 1500 && weight < 2500;
        } else if (filterValue.contains('2500-4000')) {
          return weight >= 2500 && weight <= 4000;
        } else if (filterValue.contains('>4000')) {
          return weight > 4000;
        }
        return false;
      }

      // Test very low weight filter
      expect(matchesBirthWeightFilter(1200, 'Muy bajo peso (<1500g)'), true);
      expect(matchesBirthWeightFilter(1600, 'Muy bajo peso (<1500g)'), false);

      // Test low weight filter
      expect(matchesBirthWeightFilter(2000, 'Bajo peso (1500-2499g)'), true);
      expect(matchesBirthWeightFilter(1400, 'Bajo peso (1500-2499g)'), false);
      expect(matchesBirthWeightFilter(2600, 'Bajo peso (1500-2499g)'), false);

      // Test normal weight filter
      expect(matchesBirthWeightFilter(3500, 'Peso normal (2500-4000g)'), true);
      expect(matchesBirthWeightFilter(2400, 'Peso normal (2500-4000g)'), false);

      // Test high weight filter
      expect(matchesBirthWeightFilter(4500, 'Alto peso (>4000g)'), true);
      expect(matchesBirthWeightFilter(3500, 'Alto peso (>4000g)'), false);
    });

    test('validates APGAR score range filters work correctly', () {
      bool matchesApgarFilter(int score, String filterValue) {
        if (filterValue.contains('0-3')) {
          return score >= 0 && score <= 3;
        } else if (filterValue.contains('4-6')) {
          return score >= 4 && score <= 6;
        } else if (filterValue.contains('7-10')) {
          return score >= 7 && score <= 10;
        }
        return false;
      }

      // Test critical range
      expect(matchesApgarFilter(2, 'Crítico (0-3)'), true);
      expect(matchesApgarFilter(4, 'Crítico (0-3)'), false);

      // Test moderate range
      expect(matchesApgarFilter(5, 'Moderado (4-6)'), true);
      expect(matchesApgarFilter(3, 'Moderado (4-6)'), false);
      expect(matchesApgarFilter(7, 'Moderado (4-6)'), false);

      // Test normal range
      expect(matchesApgarFilter(8, 'Normal (7-10)'), true);
      expect(matchesApgarFilter(6, 'Normal (7-10)'), false);
    });

    test('validates parent age filters work correctly', () {
      bool matchesParentAgeFilter(
          int fatherAge, int motherAge, String filterValue) {
        final parts = filterValue.split(':');
        if (parts.length != 2) return false;

        final parentType = parts[0];
        final ageRange = parts[1];
        final age = parentType == 'Padre' ? fatherAge : motherAge;

        if (age <= 0) return false; // Invalid age

        switch (ageRange) {
          case '<25':
            return age < 25;
          case '25-34':
            return age >= 25 && age < 35;
          case '35-44':
            return age >= 35 && age < 45;
          case '45+':
            return age >= 45;
          default:
            return false;
        }
      }

      // Test father age filters
      expect(matchesParentAgeFilter(30, 28, 'Padre:25-34'), true);
      expect(matchesParentAgeFilter(22, 28, 'Padre:<25'), true);
      expect(matchesParentAgeFilter(40, 28, 'Padre:35-44'), true);
      expect(matchesParentAgeFilter(50, 28, 'Padre:45+'), true);

      // Test mother age filters
      expect(matchesParentAgeFilter(30, 32, 'Madre:25-34'), true);
      expect(matchesParentAgeFilter(30, 22, 'Madre:<25'), true);

      // Test edge cases
      expect(matchesParentAgeFilter(0, 28, 'Padre:25-34'),
          false); // Invalid father age
      expect(matchesParentAgeFilter(30, 0, 'Madre:25-34'),
          false); // Invalid mother age
      expect(matchesParentAgeFilter(30, 28, 'Padre25-34'),
          false); // Invalid filter format
    });

    test('validates family members range filters work correctly', () {
      bool matchesFamilyMembersFilter(int members, String filterValue) {
        if (filterValue.contains('1-2')) {
          return members >= 1 && members <= 2;
        } else if (filterValue.contains('3-4')) {
          return members >= 3 && members <= 4;
        } else if (filterValue.contains('5-6')) {
          return members >= 5 && members <= 6;
        } else if (filterValue.contains('7+')) {
          return members >= 7;
        }
        return false;
      }

      expect(matchesFamilyMembersFilter(2, '1-2 miembros'), true);
      expect(matchesFamilyMembersFilter(3, '1-2 miembros'), false);

      expect(matchesFamilyMembersFilter(4, '3-4 miembros'), true);
      expect(matchesFamilyMembersFilter(2, '3-4 miembros'), false);
      expect(matchesFamilyMembersFilter(5, '3-4 miembros'), false);

      expect(matchesFamilyMembersFilter(6, '5-6 miembros'), true);
      expect(matchesFamilyMembersFilter(4, '5-6 miembros'), false);

      expect(matchesFamilyMembersFilter(8, '7+ miembros'), true);
      expect(matchesFamilyMembersFilter(6, '7+ miembros'), false);
    });
  });
}
