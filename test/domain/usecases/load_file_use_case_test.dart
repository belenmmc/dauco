import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/domain/usecases/load_file_use_case.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate a mock for ImportRepository
@GenerateMocks([ImportRepository])
import 'load_file_use_case_test.mocks.dart';

void main() {
  late LoadFileUseCase loadFileUseCase;
  late MockImportRepository mockImportRepository;

  setUp(() {
    mockImportRepository = MockImportRepository();
    loadFileUseCase = LoadFileUseCase(importRepository: mockImportRepository);
  });

  group('LoadFileUseCase', () {
    test('should return Excel when repository succeeds', () async {
      // Arrange
      final mockExcel = Excel.createExcel(); // Create a mock Excel object
      when(mockImportRepository.loadFile()).thenAnswer((_) async => mockExcel);

      // Act
      final result = await loadFileUseCase.execute();

      // Assert
      expect(result, equals(mockExcel));
      verify(mockImportRepository.loadFile()).called(1);
    });

    test('should return null when repository returns null', () async {
      // Arrange
      when(mockImportRepository.loadFile()).thenAnswer((_) async => null);

      // Act
      final result = await loadFileUseCase.execute();

      // Assert
      expect(result, isNull);
      verify(mockImportRepository.loadFile()).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(mockImportRepository.loadFile())
          .thenThrow(Exception('Failed to load file'));

      // Act & Assert
      expect(() => loadFileUseCase.execute(), throwsException);
      verify(mockImportRepository.loadFile()).called(1);
    });
  });
}
