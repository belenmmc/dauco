import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dauco/data/services/import_service.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:excel/excel.dart';

import 'package:mockito/annotations.dart';
import 'import_repository_test.mocks.dart';

@GenerateMocks([ImportService])
void main() {
  late MockImportService mockService;
  late ImportRepository repository;

  setUp(() {
    mockService = MockImportService();
    repository = ImportRepository(importService: mockService);
  });

  group('ImportRepository', () {
    test('loadFile calls ImportService.loadFile', () async {
      final mockExcel = Excel.createExcel();
      when(mockService.loadFile()).thenAnswer((_) async => mockExcel);

      final result = await repository.loadFile();

      expect(result, equals(mockExcel));
      verify(mockService.loadFile()).called(1);
    });

    test('getUsers calls ImportService.getUsers', () async {
      final fakeExcel = Excel.createExcel();
      final expectedUsers = [
        ImportedUser(
          managerId: 1,
          name: 'Ana',
          surname: 'Martínez',
          yes: true,
          registeredAt: DateTime(2024, 1, 1),
          zone: 'Centro',
          minorsNum: 2,
        ),
      ];

      when(mockService.getUsers(fakeExcel, page: 1, pageSize: 10))
          .thenAnswer((_) async => expectedUsers);

      final result = await repository.getUsers(fakeExcel, 1, 10);

      expect(result, expectedUsers);
      verify(mockService.getUsers(fakeExcel, page: 1, pageSize: 10)).called(1);
    });

    test('getMinors calls ImportService.getMinors', () async {
      final fakeExcel = Excel.createExcel();
      final expectedMinors = [
        Minor(
          minorId: 1,
          reference: 1,
          managerId: 1,
          birthdate: DateTime(2020, 1, 1),
          ageRange: '0-3',
          registeredAt: DateTime(2024, 1, 1),
          testsNum: 2,
          completedTests: 1,
          sex: 'F',
          zipCode: 12345,
          fatherAge: 30,
          motherAge: 28,
          fatherJob: 'Engineer',
          motherJob: 'Teacher',
          fatherStudies: 'Bachelor',
          motherStudies: 'Master',
          parentsCivilStatus: 'Married',
          siblings: 1,
          siblingsPosition: 1,
          birthType: 'Natural',
          gestationWeeks: 38,
          birthIncidents: 'None',
          birthWeight: 3200,
          socioeconomicSituation: 'Average',
          familyBackground: 'None',
          familyMembers: 3,
          familyDisabilities: 'None',
          schoolingLevel: 'Preschool',
          schoolingObservations: 'Normal',
          relevantDiseases: 'None',
          evaluationReason: 'Routine',
          apgarTest: 8,
          adoption: 0,
          clinicalJudgement: 'Normal',
        )
      ];

      when(mockService.getMinors(fakeExcel, page: 1, pageSize: 10))
          .thenAnswer((_) async => expectedMinors);

      final result = await repository.getMinors(fakeExcel, 1, 10);

      expect(result, expectedMinors);
      verify(mockService.getMinors(fakeExcel, page: 1, pageSize: 10)).called(1);
    });

    test('getTests calls ImportService.getTests', () async {
      final fakeExcel = Excel.createExcel();
      final expectedTests = [
        Test(
          testId: 1,
          minorId: 1,
          registeredAt: DateTime(2024, 1, 1),
          cronologicalAge: '3',
          evolutionaryAge: '2.5',
          mChatTest: 'Passed',
          progress: 'Good',
          activeAreas: 'Language',
          professionalType: 'Psychologist',
        )
      ];

      when(mockService.getTests(fakeExcel, 1))
          .thenAnswer((_) async => expectedTests);

      final result = await repository.getTests(fakeExcel, 1);

      expect(result, expectedTests);
      verify(mockService.getTests(fakeExcel, 1)).called(1);
    });

    test('getItems calls ImportService.getItems', () async {
      final fakeExcel = Excel.createExcel();
      final expectedItems = [
        Item(
          responseId: 1,
          itemId: 101,
          item: 'Pointing',
          testId: 1,
          area: 'Communication',
          question: 'Does the child point?',
          answer: 'Yes',
        )
      ];

      when(mockService.getItems(fakeExcel, 1))
          .thenAnswer((_) async => expectedItems);

      final result = await repository.getItems(fakeExcel, 1);

      expect(result, expectedItems);
      verify(mockService.getItems(fakeExcel, 1)).called(1);
    });
  });
}
