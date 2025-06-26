import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/usecases/get_minors_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ImportRepository])
import 'get_minors_use_case_test.mocks.dart';

void main() {
  late GetMinorsUseCase getMinorsUseCase;
  late MockImportRepository mockImportRepository;

  // Test data
  final mockFile = Object();
  final now = DateTime.now();
  final testMinors = [
    Minor(
      minorId: 1,
      reference: 1,
      managerId: 101,
      birthdate: DateTime(2018, 5, 15),
      ageRange: '3-5 years',
      registeredAt: now,
      testsNum: 5,
      completedTests: 3,
      sex: 'Male',
      zipCode: 28001,
      fatherAge: 35,
      motherAge: 32,
      fatherJob: 'Engineer',
      motherJob: 'Teacher',
      fatherStudies: 'University',
      motherStudies: 'University',
      parentsCivilStatus: 'Married',
      siblings: 1,
      siblingsPosition: 1,
      birthType: 'Natural',
      gestationWeeks: 40,
      birthIncidents: 'None',
      birthWeight: 3200,
      socioeconomicSituation: 'Middle class',
      familyBackground: 'No relevant history',
      familyMembers: 4,
      familyDisabilities: 'None',
      schoolingLevel: 'Preschool',
      schoolingObservations: 'Normal adaptation',
      relevantDiseases: 'None',
      evaluationReason: 'Routine checkup',
      apgarTest: 9,
      adoption: 0,
      clinicalJudgement: 'Normal development',
    ),
    Minor(
      minorId: 2,
      reference: 1,
      managerId: 102,
      birthdate: DateTime(2019, 3, 10),
      ageRange: '2-3 years',
      registeredAt: now.subtract(Duration(days: 30)),
      testsNum: 3,
      completedTests: 2,
      sex: 'Female',
      zipCode: 28002,
      fatherAge: 40,
      motherAge: 38,
      fatherJob: 'Doctor',
      motherJob: 'Nurse',
      fatherStudies: 'University',
      motherStudies: 'University',
      parentsCivilStatus: 'Divorced',
      siblings: 2,
      siblingsPosition: 2,
      birthType: 'C-section',
      gestationWeeks: 38,
      birthIncidents: 'Mild jaundice',
      birthWeight: 2900,
      socioeconomicSituation: 'Upper middle class',
      familyBackground: 'Allergies',
      familyMembers: 5,
      familyDisabilities: 'Grandfather with diabetes',
      schoolingLevel: 'Daycare',
      schoolingObservations: 'Some separation anxiety',
      relevantDiseases: 'None',
      evaluationReason: 'Speech delay',
      apgarTest: 8,
      adoption: 0,
      clinicalJudgement: 'Needs follow-up',
    ),
  ];

  setUp(() {
    mockImportRepository = MockImportRepository();
    getMinorsUseCase = GetMinorsUseCase(importRepository: mockImportRepository);
  });

  group('GetMinorsUseCase', () {
    test('should call repository with correct pagination parameters', () async {
      // Arrange
      when(mockImportRepository.getMinors(any, any, any))
          .thenAnswer((_) async => testMinors);

      // Act
      await getMinorsUseCase.execute(mockFile, page: 2, pageSize: 10);

      // Assert
      verify(mockImportRepository.getMinors(mockFile, 2, 10)).called(1);
    });

    test('should return complete minor data with all fields', () async {
      // Arrange
      when(mockImportRepository.getMinors(any, any, any))
          .thenAnswer((_) async => testMinors);

      // Act
      final result = await getMinorsUseCase.execute(mockFile);

      // Assert
      expect(result, isA<List<Minor>>());
      expect(result.length, 2);

      // Verify first minor
      expect(result[0].minorId, 1);
      expect(result[0].reference, 'REF-001');
      expect(result[0].managerId, 101);
      expect(result[0].birthdate, DateTime(2018, 5, 15));
      expect(result[0].ageRange, '3-5 years');
      expect(result[0].sex, 'Male');
      expect(result[0].fatherJob, 'Engineer');
      expect(result[0].motherJob, 'Teacher');
      expect(result[0].apgarTest, 9);
      expect(result[0].clinicalJudgement, 'Normal development');

      // Verify second minor
      expect(result[1].minorId, 2);
      expect(result[1].reference, 'REF-002');
      expect(result[1].birthType, 'C-section');
      expect(result[1].evaluationReason, 'Speech delay');
      expect(result[1].clinicalJudgement, 'Needs follow-up');
    });

    test('should handle pagination correctly', () async {
      // Arrange
      when(mockImportRepository.getMinors(any, 1, 1))
          .thenAnswer((_) async => [testMinors[0]]);
      when(mockImportRepository.getMinors(any, 2, 1))
          .thenAnswer((_) async => [testMinors[1]]);

      // Act - First page
      final page1 =
          await getMinorsUseCase.execute(mockFile, page: 1, pageSize: 1);
      // Act - Second page
      final page2 =
          await getMinorsUseCase.execute(mockFile, page: 2, pageSize: 1);

      // Assert
      expect(page1.length, 1);
      expect(page1[0].minorId, 1);
      expect(page2.length, 1);
      expect(page2[0].minorId, 2);
    });

    test('should handle empty results', () async {
      // Arrange
      when(mockImportRepository.getMinors(any, any, any))
          .thenAnswer((_) async => []);

      // Act
      final result = await getMinorsUseCase.execute(mockFile);

      // Assert
      expect(result, isEmpty);
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      when(mockImportRepository.getMinors(any, any, any))
          .thenThrow(Exception('File parsing error'));

      // Act & Assert
      expect(
          () => getMinorsUseCase.execute(mockFile), throwsA(isA<Exception>()));
    });

    test('should handle edge case values', () async {
      // Arrange
      final edgeCaseMinor = Minor(
        minorId: 3,
        reference: 1,
        managerId: 0,
        birthdate: DateTime(1900, 1, 1),
        ageRange: '',
        registeredAt: DateTime(0),
        testsNum: 0,
        completedTests: 0,
        sex: '',
        zipCode: 0,
        fatherAge: 0,
        motherAge: 0,
        fatherJob: '',
        motherJob: '',
        fatherStudies: '',
        motherStudies: '',
        parentsCivilStatus: '',
        siblings: 0,
        siblingsPosition: 0,
        birthType: '',
        gestationWeeks: 0,
        birthIncidents: '',
        birthWeight: 0,
        socioeconomicSituation: '',
        familyBackground: '',
        familyMembers: 0,
        familyDisabilities: '',
        schoolingLevel: '',
        schoolingObservations: '',
        relevantDiseases: '',
        evaluationReason: '',
        apgarTest: 0,
        adoption: 0,
        clinicalJudgement: '',
      );

      when(mockImportRepository.getMinors(any, any, any))
          .thenAnswer((_) async => [edgeCaseMinor]);

      // Act
      final result = await getMinorsUseCase.execute(mockFile);

      // Assert
      expect(result[0].minorId, 3);
      expect(result[0].reference, 'EDGE-CASE');
      expect(result[0].birthdate, DateTime(1900, 1, 1));
      expect(result[0].ageRange, isEmpty);
      expect(result[0].apgarTest, 0);
    });

    test('should handle maximum page size', () async {
      // Arrange
      const largePageSize = 1000;
      final manyMinors = List.generate(
          1000,
          (i) => Minor(
                minorId: i,
                reference: 1,
                managerId: i,
                birthdate: DateTime.now().subtract(Duration(days: i)),
                ageRange: '${i % 10}-${i % 10 + 1} years',
                registeredAt: DateTime.now(),
                testsNum: i % 5,
                completedTests: i % 3,
                sex: i % 2 == 0 ? 'Male' : 'Female',
                zipCode: 28000 + i,
                fatherAge: 30 + i % 20,
                motherAge: 28 + i % 20,
                fatherJob: 'Job $i',
                motherJob: 'Job ${i + 1}',
                fatherStudies: i % 2 == 0 ? 'University' : 'High school',
                motherStudies: i % 2 == 0 ? 'University' : 'High school',
                parentsCivilStatus: ['Married', 'Divorced', 'Single'][i % 3],
                siblings: i % 4,
                siblingsPosition: i % 3,
                birthType: ['Natural', 'C-section'][i % 2],
                gestationWeeks: 36 + i % 5,
                birthIncidents: i % 5 == 0 ? 'None' : 'Minor',
                birthWeight: 2500 + (i % 10) * 100,
                socioeconomicSituation: ['Low', 'Middle', 'High'][i % 3],
                familyBackground: i % 4 == 0 ? 'None' : 'Some',
                familyMembers: 2 + i % 5,
                familyDisabilities: i % 5 == 0 ? 'None' : 'Some',
                schoolingLevel: ['None', 'Daycare', 'Preschool'][i % 3],
                schoolingObservations:
                    i % 2 == 0 ? 'Normal' : 'Needs attention',
                relevantDiseases: i % 3 == 0 ? 'None' : 'Condition $i',
                evaluationReason: ['Routine', 'Concern', 'Follow-up'][i % 3],
                apgarTest: 7 + i % 3,
                adoption: i % 10 == 0 ? 1 : 0,
                clinicalJudgement: i % 2 == 0 ? 'Normal' : 'Needs evaluation',
              ));

      when(mockImportRepository.getMinors(any, 1, largePageSize))
          .thenAnswer((_) async => manyMinors);

      // Act
      final result = await getMinorsUseCase.execute(mockFile,
          page: 1, pageSize: largePageSize);

      // Assert
      expect(result.length, largePageSize);
      verify(mockImportRepository.getMinors(mockFile, 1, largePageSize))
          .called(1);
    });
  });
}
