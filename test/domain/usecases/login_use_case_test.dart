import 'package:dauco/data/repositories/implementation/user_repository.dart';
import 'package:dauco/domain/usecases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks
@GenerateMocks([UserRepository])
import 'login_use_case_test.mocks.dart';

void main() {
  late LoginUseCase loginUseCase;
  late MockUserRepository mockUserRepository;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  setUp(() {
    mockUserRepository = MockUserRepository();
    loginUseCase = LoginUseCase(userRepository: mockUserRepository);
  });

  group('LoginUseCase', () {
    test('should call userRepository.login with correct parameters', () async {
      // Arrange
      when(mockUserRepository.login(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      await loginUseCase.execute(testEmail, testPassword);

      // Assert
      verify(mockUserRepository.login(testEmail, testPassword)).called(1);
    });

    test('should complete successfully when repository succeeds', () async {
      // Arrange
      when(mockUserRepository.login(any, any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      expect(
          () => loginUseCase.execute(testEmail, testPassword), returnsNormally);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(mockUserRepository.login(any, any))
          .thenThrow(Exception('Login failed'));

      // Act & Assert
      expect(
          () => loginUseCase.execute(testEmail, testPassword), throwsException);
    });

    test('should not catch specific exceptions thrown by repository', () async {
      // Arrange
      when(mockUserRepository.login(any, any))
          .thenThrow(FormatException('Invalid email format'));

      // Act & Assert
      expect(() => loginUseCase.execute(testEmail, testPassword),
          throwsA(isA<FormatException>()));
    });

    test('should handle empty email or password', () async {
      // Arrange
      when(mockUserRepository.login('', any))
          .thenThrow(ArgumentError('Email cannot be empty'));
      when(mockUserRepository.login(any, ''))
          .thenThrow(ArgumentError('Password cannot be empty'));

      // Act & Assert for empty email
      expect(() => loginUseCase.execute('', testPassword),
          throwsA(isA<ArgumentError>()));

      // Act & Assert for empty password
      expect(() => loginUseCase.execute(testEmail, ''),
          throwsA(isA<ArgumentError>()));
    });
  });
}
