import 'package:dauco/presentation/blocs/load_file_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:excel/excel.dart';

import 'package:dauco/domain/usecases/load_file_use_case.dart';

import 'load_file_bloc_test.mocks.dart';

@GenerateMocks([LoadFileUseCase])
void main() {
  late MockLoadFileUseCase mockLoadFileUseCase;
  late LoadFileBloc bloc;

  setUp(() {
    mockLoadFileUseCase = MockLoadFileUseCase();
    bloc = LoadFileBloc(loadFileUseCase: mockLoadFileUseCase);
  });

  group('LoadFileBloc', () {
    test('initial state is LoadFileInitial', () {
      expect(bloc.state, isA<LoadFileInitial>());
    });

    blocTest<LoadFileBloc, LoadFileState>(
      'emits [LoadFileLoading, LoadFileSuccess] when file is loaded successfully',
      build: () {
        final fakeExcel = Excel.createExcel();
        when(mockLoadFileUseCase.execute()).thenAnswer((_) async => fakeExcel);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFileEvent()),
      expect: () => [
        isA<LoadFileLoading>(),
        isA<LoadFileSuccess>().having((s) => s.file, 'file', isNotNull),
      ],
    );

    blocTest<LoadFileBloc, LoadFileState>(
      'emits [LoadFileLoading, LoadFileCancelled] when returned file is null',
      build: () {
        when(mockLoadFileUseCase.execute()).thenAnswer((_) async => null);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFileEvent()),
      expect: () => [
        isA<LoadFileLoading>(),
        isA<LoadFileCancelled>(),
      ],
    );

    blocTest<LoadFileBloc, LoadFileState>(
      'emits [LoadFileLoading, LoadFileError] when an exception is thrown',
      build: () {
        when(mockLoadFileUseCase.execute()).thenThrow(Exception("Test error"));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFileEvent()),
      expect: () => [
        isA<LoadFileLoading>(),
        isA<LoadFileError>()
            .having((e) => e.error, 'error', contains('Test error')),
      ],
    );
  });
}
