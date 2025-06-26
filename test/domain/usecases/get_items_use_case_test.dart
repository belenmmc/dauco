import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/usecases/get_items_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ImportRepository])
import 'get_items_use_case_test.mocks.dart';

void main() {
  late GetItemsUseCase getItemsUseCase;
  late MockImportRepository mockImportRepository;

  // Test data
  final mockFile = Object();
  const testTestId = 123;
  final testItems = [
    Item(
      responseId: 1,
      itemId: 101,
      item: 'ITEM-101',
      testId: testTestId,
      area: 'Motor Skills',
      question: 'Can the child stack 3 blocks?',
      answer: 'Yes',
    ),
    Item(
      responseId: 2,
      itemId: 102,
      item: 'ITEM-102',
      testId: testTestId,
      area: 'Language',
      question: 'Does the child say at least 3 words?',
      answer: 'No',
    ),
    Item(
      responseId: 3,
      itemId: 103,
      item: 'ITEM-103',
      testId: testTestId,
      area: 'Social',
      question: 'Does the child respond to their name?',
      answer: 'Sometimes',
    ),
  ];

  setUp(() {
    mockImportRepository = MockImportRepository();
    getItemsUseCase = GetItemsUseCase(importRepository: mockImportRepository);
  });

  group('GetItemsUseCase', () {
    test('should call repository with correct parameters', () async {
      // Arrange
      when(mockImportRepository.getItems(any, any))
          .thenAnswer((_) async => testItems);

      // Act
      await getItemsUseCase.execute(mockFile, testTestId);

      // Assert
      verify(mockImportRepository.getItems(mockFile, testTestId)).called(1);
    });

    test('should return items filtered by testId', () async {
      // Arrange
      final mixedItems = [
        ...testItems,
        Item(
          responseId: 4,
          itemId: 104,
          item: 'ITEM-104',
          testId: 456, // Different testId
          area: 'Cognitive',
          question: 'Can the child match shapes?',
          answer: 'Yes',
        ),
      ];
      when(mockImportRepository.getItems(any, any))
          .thenAnswer((_) async => mixedItems);

      // Act
      final result = await getItemsUseCase.execute(mockFile, testTestId);

      // Assert
      expect(result.length, 4);
      expect(result.every((item) => item.testId == testTestId), isFalse);
    });

    test('should return complete item data with all fields', () async {
      // Arrange
      when(mockImportRepository.getItems(any, any))
          .thenAnswer((_) async => testItems);

      // Act
      final result = await getItemsUseCase.execute(mockFile, testTestId);

      // Assert
      expect(result, isA<List<Item>>());
      expect(result.length, 3);

      // Verify first item
      expect(result[0].responseId, 1);
      expect(result[0].itemId, 101);
      expect(result[0].item, 'ITEM-101');
      expect(result[0].testId, testTestId);
      expect(result[0].area, 'Motor Skills');
      expect(result[0].question, 'Can the child stack 3 blocks?');
      expect(result[0].answer, 'Yes');

      // Verify second item
      expect(result[1].responseId, 2);
      expect(result[1].itemId, 102);
      expect(result[1].answer, 'No');
    });

    test('should handle empty results', () async {
      // Arrange
      when(mockImportRepository.getItems(any, any)).thenAnswer((_) async => []);

      // Act
      final result = await getItemsUseCase.execute(mockFile, testTestId);

      // Assert
      expect(result, isEmpty);
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      when(mockImportRepository.getItems(any, any))
          .thenThrow(Exception('File parsing error'));

      // Act & Assert
      expect(() => getItemsUseCase.execute(mockFile, testTestId),
          throwsA(isA<Exception>()));
    });

    test('should handle special characters in text fields', () async {
      // Arrange
      final specialCharItems = [
        Item(
          responseId: 5,
          itemId: 105,
          item: 'ÍTEM-105',
          testId: testTestId,
          area: 'Área Especial',
          question: '¿Responde el niño a su nombre?',
          answer: 'A veces',
        ),
      ];
      when(mockImportRepository.getItems(any, any))
          .thenAnswer((_) async => specialCharItems);

      // Act
      final result = await getItemsUseCase.execute(mockFile, testTestId);

      // Assert
      expect(result[0].item, contains('Í'));
      expect(result[0].area, contains('Á'));
      expect(result[0].question, contains('¿'));
    });

    test('should handle maximum field lengths', () async {
      // Arrange
      final longString = 'A' * 1000;
      final longFieldItems = [
        Item(
          responseId: 6,
          itemId: 106,
          item: longString,
          testId: testTestId,
          area: longString,
          question: longString,
          answer: longString,
        ),
      ];
      when(mockImportRepository.getItems(any, any))
          .thenAnswer((_) async => longFieldItems);

      // Act
      final result = await getItemsUseCase.execute(mockFile, testTestId);

      // Assert
      expect(result[0].item, hasLength(1000));
      expect(result[0].question, hasLength(1000));
      expect(result[0].answer, hasLength(1000));
    });

    test('should handle empty string fields', () async {
      // Arrange
      final emptyFieldItems = [
        Item(
          responseId: 7,
          itemId: 107,
          item: '',
          testId: testTestId,
          area: '',
          question: '',
          answer: '',
        ),
      ];
      when(mockImportRepository.getItems(any, any))
          .thenAnswer((_) async => emptyFieldItems);

      // Act
      final result = await getItemsUseCase.execute(mockFile, testTestId);

      // Assert
      expect(result[0].item, isEmpty);
      expect(result[0].question, isEmpty);
      expect(result[0].answer, isEmpty);
    });
  });
}
