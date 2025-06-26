import 'package:dauco/presentation/blocs/import_users_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:excel/excel.dart';

import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/usecases/import_users_use_case.dart';

import 'import_users_bloc_test.mocks.dart';

@GenerateMocks([ImportUsersUseCase])
void main() {
  late MockImportUsersUseCase mockImportUsersUseCase;
  late ImportUsersBloc importUsersBloc;

  setUp(() {
    mockImportUsersUseCase = MockImportUsersUseCase();
    importUsersBloc =
        ImportUsersBloc(importUsersUseCase: mockImportUsersUseCase);
  });

  final fakeExcel = Excel.createExcel();
  final importedUsers = [
    ImportedUser(
      managerId: 1,
      name: 'Alice',
      surname: 'Smith',
      yes: true,
      registeredAt: DateTime(2023, 10, 1),
      zone: 'North',
      minorsNum: 2,
    ),
    ImportedUser(
      managerId: 2,
      name: 'Bob',
      surname: 'Johnson',
      yes: false,
      registeredAt: DateTime(2023, 11, 15),
      zone: 'East',
      minorsNum: 0,
    ),
  ];

  group('ImportUsersBloc', () {
    test('initial state is ImportUsersInitial', () {
      expect(importUsersBloc.state, isA<ImportUsersInitial>());
    });

    blocTest<ImportUsersBloc, ImportUsersState>(
      'emits [ImportUsersLoading, ImportUsersSuccess] when ImportEvent is successful',
      build: () {
        when(mockImportUsersUseCase.execute(fakeExcel, page: 1))
            .thenAnswer((_) async => importedUsers);
        return importUsersBloc;
      },
      act: (bloc) => bloc.add(ImportEvent(fakeExcel)),
      expect: () => [
        isA<ImportUsersLoading>(),
        isA<ImportUsersSuccess>()
            .having(
                (s) => s.users.length, 'number of users', importedUsers.length)
            .having((s) => s.users.first.name, 'first user name', 'Alice'),
      ],
    );

    blocTest<ImportUsersBloc, ImportUsersState>(
      'emits [ImportUsersLoading, ImportUsersSuccess] when LoadMoreUsersEvent is successful',
      build: () {
        when(mockImportUsersUseCase.execute(fakeExcel, page: 2))
            .thenAnswer((_) async => [importedUsers[1]]);
        return importUsersBloc;
      },
      act: (bloc) => bloc.add(LoadMoreUsersEvent(fakeExcel, 2)),
      expect: () => [
        isA<ImportUsersLoading>(),
        isA<ImportUsersSuccess>()
            .having((s) => s.users.first.name, 'first user name', 'Bob'),
      ],
    );

    blocTest<ImportUsersBloc, ImportUsersState>(
      'emits [ImportUsersLoading, ImportUsersError] when ImportEvent fails',
      build: () {
        when(mockImportUsersUseCase.execute(fakeExcel, page: 1))
            .thenThrow(Exception('Something went wrong'));
        return importUsersBloc;
      },
      act: (bloc) => bloc.add(ImportEvent(fakeExcel)),
      expect: () => [
        isA<ImportUsersLoading>(),
        isA<ImportUsersError>()
            .having((e) => e.error, 'error', contains('Something went wrong')),
      ],
    );
  });
}
