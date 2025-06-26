import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/domain/usecases/get_tests_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ImportRepository])
import 'get_tests_use_case_test.mocks.dart';

void main() {
  late GetTestsUseCase getTestsUseCase;
  late MockImportRepository mockImportRepository;

  // Test data
  final mockFile = Object();
  const testMinorId = 123;
  final now = DateTime.now();
  final testTests = [
    Test(
      testId: 1,
      minorId: testMinorId,
      registeredAt: now,
      cronologicalAge: '2 years',
      evolutionaryAge: '18 months',
      mChatTest: 'Passed',
      progress: 'Good',
      activeAreas: 'Motor,Language',
      professionalType: 'Pediatrician',
    ),
    Test(
      testId: 2,
      minorId: testMinorId,
      registeredAt: now.subtract(Duration(days: 30)),
      cronologicalAge: '3 years',
      evolutionaryAge: '2 years',
      mChatTest: 'Failed',
      progress: 'Excellent',
      activeAreas: 'Social,Cognitive',
      professionalType: 'Psychologist',
    ),
  ];

  setUp(() {
    mockImportRepository = MockImportRepository();
    getTestsUseCase = GetTestsUseCase(importRepository: mockImportRepository);
  });

  group('GetTestsUseCase', () {
    test('should return complete test data with all fields', () async {
      // Arrange
      when(mockImportRepository.getTests(any, any))
          .thenAnswer((_) async => testTests);

      // Act
      final result = await getTestsUseCase.execute(mockFile, testMinorId);

      // Assert
      expect(result, isA<List<Test>>());
      expect(result.length, 2);

      // Verify first test
      expect(result[0].testId, 1);
      expect(result[0].minorId, testMinorId);
      expect(result[0].registeredAt, now);
      expect(result[0].cronologicalAge, '2 years');
      expect(result[0].evolutionaryAge, '18 months');
      expect(result[0].mChatTest, 'Passed');
      expect(result[0].progress, 'Good');
      expect(result[0].activeAreas, 'Motor,Language');
      expect(result[0].professionalType, 'Pediatrician');

      // Verify second test
      expect(result[1].testId, 2);
      expect(result[1].minorId, testMinorId);
      expect(result[1].registeredAt, now.subtract(Duration(days: 30)));
      expect(result[1].cronologicalAge, '3 years');
      expect(result[1].evolutionaryAge, '2 years');
      expect(result[1].mChatTest, 'Failed');
      expect(result[1].progress, 'Excellent');
      expect(result[1].activeAreas, 'Social,Cognitive');
      expect(result[1].professionalType, 'Psychologist');
    });

    test('should filter tests by minorId', () async {
      // Arrange
      final mixedTests = [
        ...testTests,
        Test(
          testId: 3,
          minorId: 456, // Different minorId
          registeredAt: now,
          cronologicalAge: '4 years',
          evolutionaryAge: '3 years',
          mChatTest: 'Passed',
          progress: 'Average',
          activeAreas: 'All',
          professionalType: 'Therapist',
        ),
      ];
      when(mockImportRepository.getTests(any, any))
          .thenAnswer((_) async => mixedTests);

      // Act
      final result = await getTestsUseCase.execute(mockFile, testMinorId);

      // Assert
      expect(result.length, 2);
      expect(result.every((test) => test.minorId == testMinorId), isTrue);
    });

    test('should handle required field validation', () async {
      // Arrange
      when(mockImportRepository.getTests(any, any))
          .thenThrow(FormatException('Missing required fields'));

      // Act & Assert
      expect(() => getTestsUseCase.execute(mockFile, testMinorId),
          throwsA(isA<FormatException>()));
    });

    test('should handle date parsing errors', () async {
      // Arrange
      final invalidTests = [
        Test(
          testId: 1,
          minorId: testMinorId,
          registeredAt: DateTime(0), // Invalid date
          cronologicalAge: '2 years',
          evolutionaryAge: '18 months',
          mChatTest: 'Passed',
          progress: 'Good',
          activeAreas: 'Motor,Language',
          professionalType: 'Pediatrician',
        ),
      ];
      when(mockImportRepository.getTests(any, any))
          .thenAnswer((_) async => invalidTests);

      // Act
      final result = await getTestsUseCase.execute(mockFile, testMinorId);

      // Assert
      expect(result[0].registeredAt, DateTime(0));
      // Add additional validation if needed
    });

    test('should handle empty string fields', () async {
      // Arrange
      final emptyFieldTests = [
        Test(
          testId: 1,
          minorId: testMinorId,
          registeredAt: now,
          cronologicalAge: '',
          evolutionaryAge: '',
          mChatTest: '',
          progress: '',
          activeAreas: '',
          professionalType: '',
        ),
      ];
      when(mockImportRepository.getTests(any, any))
          .thenAnswer((_) async => emptyFieldTests);

      // Act
      final result = await getTestsUseCase.execute(mockFile, testMinorId);

      // Assert
      expect(result[0].cronologicalAge, isEmpty);
      expect(result[0].evolutionaryAge, isEmpty);
      expect(result[0].mChatTest, isEmpty);
      expect(result[0].progress, isEmpty);
      expect(result[0].activeAreas, isEmpty);
      expect(result[0].professionalType, isEmpty);
    });
  });
}
