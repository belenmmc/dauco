import 'package:dauco/presentation/blocs/get_items_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:excel/excel.dart';

import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/usecases/get_items_use_case.dart';

import 'get_items_bloc_test.mocks.dart';

@GenerateMocks([GetItemsUseCase])
void main() {
  late MockGetItemsUseCase mockGetItemsUseCase;
  late GetItemsBloc bloc;

  setUp(() {
    mockGetItemsUseCase = MockGetItemsUseCase();
    bloc = GetItemsBloc(getItemsUseCase: mockGetItemsUseCase);
  });

  final fakeExcel = Excel.createExcel();

  final mockItems = [
    Item(
      responseId: 1,
      itemId: 101,
      item: 'Item 1',
      testId: 202,
      area: 'Area 1',
      question: 'What is your name?',
      answer: 'John Doe',
    ),
    Item(
      responseId: 2,
      itemId: 102,
      item: 'Item 2',
      testId: 202,
      area: 'Area 2',
      question: 'What is your age?',
      answer: '25',
    ),
  ];

  group('GetItemsBloc', () {
    test('initial state is GetItemsInitial', () {
      expect(bloc.state, isA<GetItemsInitial>());
    });

    blocTest<GetItemsBloc, GetItemsState>(
      'emits [GetItemsLoading, GetItemsSuccess] on successful GetEvent',
      build: () {
        when(mockGetItemsUseCase.execute(fakeExcel, 202))
            .thenAnswer((_) async => mockItems);
        return bloc;
      },
      act: (bloc) => bloc.add(GetEvent(fakeExcel, 202)),
      expect: () => [
        isA<GetItemsLoading>(),
        isA<GetItemsSuccess>()
            .having((s) => s.items.length, 'items length', 2)
            .having((s) => s.items.first.item, 'first item name', 'Item 1')
            .having(
                (s) => s.items.first.answer, 'first item answer', 'John Doe'),
      ],
    );

    blocTest<GetItemsBloc, GetItemsState>(
      'emits [GetItemsLoading, GetItemsSuccess] on successful LoadMoreItemsEvent',
      build: () {
        when(mockGetItemsUseCase.execute(fakeExcel, 202))
            .thenAnswer((_) async => mockItems);
        return bloc;
      },
      act: (bloc) => bloc.add(GetEvent(fakeExcel, 202)),
      expect: () => [
        isA<GetItemsLoading>(),
        isA<GetItemsSuccess>()
            .having((s) => s.items.length, 'items length', 2)
            .having((s) => s.items.last.item, 'last item name', 'Item 2'),
      ],
    );

    blocTest<GetItemsBloc, GetItemsState>(
      'emits [GetItemsLoading, GetItemsError] when GetEvent fails',
      build: () {
        when(mockGetItemsUseCase.execute(fakeExcel, 202))
            .thenThrow(Exception('Error fetching items'));
        return bloc;
      },
      act: (bloc) => bloc.add(GetEvent(fakeExcel, 202)),
      expect: () => [
        isA<GetItemsLoading>(),
        isA<GetItemsError>()
            .having((e) => e.error, 'error', contains('Error fetching items')),
      ],
    );
  });
}
