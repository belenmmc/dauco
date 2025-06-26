import 'package:dauco/presentation/blocs/get_tests_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:excel/excel.dart';

import 'package:dauco/domain/usecases/get_tests_use_case.dart';
import 'package:dauco/domain/entities/test.entity.dart';

import 'get_tests_bloc_test.mocks.dart';

@GenerateMocks([GetTestsUseCase])
void main() {
  late MockGetTestsUseCase mockGetTestsUseCase;
  late GetTestsBloc getTestsBloc;

  setUp(() {
    mockGetTestsUseCase = MockGetTestsUseCase();
    getTestsBloc = GetTestsBloc(getTestsUseCase: mockGetTestsUseCase);
  });

  final fakeExcel = Excel.createExcel();

  final mockTests = [
    Test(
      testId: 1,
      minorId: 10,
      registeredAt: DateTime(2024, 3, 1),
      cronologicalAge: '4y 2m',
      evolutionaryAge: '3y 8m',
      mChatTest: 'Low Risk',
      progress: 'Stable',
      activeAreas: 'Motor, Language',
      professionalType: 'Psychologist',
    ),
    Test(
      testId: 2,
      minorId: 10,
      registeredAt: DateTime(2024, 4, 1),
      cronologicalAge: '4y 3m',
      evolutionaryAge: '3y 9m',
      mChatTest: 'Medium Risk',
      progress: 'Improving',
      activeAreas: 'Cognitive',
      professionalType: 'Therapist',
    ),
  ];

  group('GetTestsBloc', () {
    test('initial state is GetTestsInitial', () {
      expect(getTestsBloc.state, isA<GetTestsInitial>());
    });

    blocTest<GetTestsBloc, GetTestsState>(
      'emits [GetTestsLoading, GetTestsSuccess] when GetEvent succeeds',
      build: () {
        when(mockGetTestsUseCase.execute(fakeExcel, 10))
            .thenAnswer((_) async => mockTests);
        return getTestsBloc;
      },
      act: (bloc) => bloc.add(GetEvent(fakeExcel, 10)),
      expect: () => [
        isA<GetTestsLoading>(),
        isA<GetTestsSuccess>()
            .having((s) => s.tests.length, 'tests length', 2)
            .having((s) => s.tests.first.testId, 'first test ID', 1)
            .having((s) => s.tests.first.professionalType, 'professional type',
                'Psychologist'),
      ],
    );

    blocTest<GetTestsBloc, GetTestsState>(
      'emits [GetTestsLoading, GetTestsError] when GetEvent throws',
      build: () {
        when(mockGetTestsUseCase.execute(fakeExcel, 10))
            .thenThrow(Exception('Failed to fetch tests'));
        return getTestsBloc;
      },
      act: (bloc) => bloc.add(GetEvent(fakeExcel, 10)),
      expect: () => [
        isA<GetTestsLoading>(),
        isA<GetTestsError>().having(
            (e) => e.error, 'error message', contains('Failed to fetch tests')),
      ],
    );
  });
}
