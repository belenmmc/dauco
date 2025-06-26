import 'package:dauco/presentation/blocs/get_minors_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:excel/excel.dart';

import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/usecases/get_minors_use_case.dart';

import 'get_minors_bloc_test.mocks.dart';

@GenerateMocks([GetMinorsUseCase])
void main() {
  late MockGetMinorsUseCase mockGetMinorsUseCase;
  late GetMinorsBloc bloc;

  setUp(() {
    mockGetMinorsUseCase = MockGetMinorsUseCase();
    bloc = GetMinorsBloc(importMinorsUseCase: mockGetMinorsUseCase);
  });

  final fakeExcel = Excel.createExcel();

  final mockMinors = [
    Minor(
      minorId: 1,
      reference: 'Ref001',
      managerId: 42,
      birthdate: DateTime(2019, 1, 1),
      ageRange: '4-5',
      registeredAt: DateTime(2024, 3, 20),
      testsNum: 10,
      completedTests: 8,
      sex: 'Female',
      zipCode: 12345,
      fatherAge: 40,
      motherAge: 38,
      fatherJob: 'Engineer',
      motherJob: 'Teacher',
      fatherStudies: 'University',
      motherStudies: 'University',
      parentsCivilStatus: 'Married',
      siblings: 2,
      siblingsPosition: 1,
      birthType: 'Natural',
      gestationWeeks: 40,
      birthIncidents: 'None',
      birthWeight: 3500,
      socioeconomicSituation: 'Middle',
      familyBackground: 'No known issues',
      familyMembers: 4,
      familyDisabilities: 'None',
      schoolingLevel: 'Kindergarten',
      schoolingObservations: 'Normal development',
      relevantDiseases: 'None',
      evaluationReason: 'Routine check',
      apgarTest: 9,
      adoption: 0,
      clinicalJudgement: 'Healthy child',
    ),
    Minor(
      minorId: 2,
      reference: 'Ref002',
      managerId: 42,
      birthdate: DateTime(2018, 6, 15),
      ageRange: '5-6',
      registeredAt: DateTime(2024, 3, 21),
      testsNum: 12,
      completedTests: 10,
      sex: 'Male',
      zipCode: 67890,
      fatherAge: 45,
      motherAge: 42,
      fatherJob: 'Doctor',
      motherJob: 'Nurse',
      fatherStudies: 'Doctorate',
      motherStudies: 'Master\'s',
      parentsCivilStatus: 'Married',
      siblings: 3,
      siblingsPosition: 2,
      birthType: 'C-section',
      gestationWeeks: 38,
      birthIncidents: 'None',
      birthWeight: 3200,
      socioeconomicSituation: 'Upper',
      familyBackground: 'No significant issues',
      familyMembers: 5,
      familyDisabilities: 'None',
      schoolingLevel: 'Primary',
      schoolingObservations: 'Exceptional performance',
      relevantDiseases: 'Asthma',
      evaluationReason: 'Follow-up',
      apgarTest: 10,
      adoption: 0,
      clinicalJudgement: 'Good health',
    ),
  ];

  group('GetMinorsBloc', () {
    test('initial state is GetMinorsInitial', () {
      expect(bloc.state, isA<GetMinorsInitial>());
    });

    blocTest<GetMinorsBloc, GetMinorsState>(
      'emits [GetMinorsLoading, GetMinorsSuccess] on successful GetEvent',
      build: () {
        when(mockGetMinorsUseCase.execute(fakeExcel, page: 1))
            .thenAnswer((_) async => mockMinors);
        return bloc;
      },
      act: (bloc) => bloc.add(GetEvent(fakeExcel)),
      expect: () => [
        isA<GetMinorsLoading>(),
        isA<GetMinorsSuccess>()
            .having((s) => s.minors.length, 'length', 2)
            .having((s) => s.minors.first.minorId, 'minorId', 1),
      ],
    );

    blocTest<GetMinorsBloc, GetMinorsState>(
      'emits [GetMinorsLoading, GetMinorsSuccess] on successful LoadMoreMinorsEvent',
      build: () {
        when(mockGetMinorsUseCase.execute(fakeExcel, page: 2))
            .thenAnswer((_) async => mockMinors);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadMoreMinorsEvent(fakeExcel, 2)),
      expect: () => [
        isA<GetMinorsLoading>(),
        isA<GetMinorsSuccess>()
            .having((s) => s.minors.length, 'length', 2)
            .having((s) => s.minors.last.reference, 'last reference', 'Ref002'),
      ],
    );

    blocTest<GetMinorsBloc, GetMinorsState>(
      'emits [GetMinorsLoading, GetMinorsError] when GetEvent fails',
      build: () {
        when(mockGetMinorsUseCase.execute(fakeExcel, page: 1))
            .thenThrow(Exception('File processing error'));
        return bloc;
      },
      act: (bloc) => bloc.add(GetEvent(fakeExcel)),
      expect: () => [
        isA<GetMinorsLoading>(),
        isA<GetMinorsError>()
            .having((e) => e.error, 'error', contains('File processing error')),
      ],
    );
  });
}
