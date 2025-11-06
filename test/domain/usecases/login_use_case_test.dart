import 'dart:async';

import 'package:dauco/data/repositories/implementation/user_repository.dart';
import 'package:dauco/domain/usecases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock classes
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    loginUseCase = LoginUseCase(userRepository: mockUserRepository);
  });

  group('LoginUseCase Tests', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const invalidEmail = 'invalid@example.com';
    const invalidPassword = 'wrongpassword';
    const emptyEmail = '';
    const emptyPassword = '';

    group('Successful Login Cases', () {
      test('execute completes successfully with valid credentials', () async {
        // Arrange
        when(() => mockUserRepository.login(testEmail, testPassword))
            .thenAnswer((_) async => Future.value());

        // Act & Assert
        await expectLater(
          loginUseCase.execute(testEmail, testPassword),
          completes,
        );

        verify(() => mockUserRepository.login(testEmail, testPassword))
            .called(1);
      });

      test('execute calls repository with exact parameters provided', () async {
        // Arrange
        const specificEmail = 'specific.user@company.com';
        const specificPassword = 'VerySecureP@ssw0rd!';

        when(() => mockUserRepository.login(specificEmail, specificPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(specificEmail, specificPassword);

        // Assert
        verify(() => mockUserRepository.login(specificEmail, specificPassword))
            .called(1);
        verifyNoMoreInteractions(mockUserRepository);
      });

      test('execute handles email with special characters', () async {
        // Arrange
        const emailWithSpecialChars = 'user+test@domain-name.co.uk';
        when(() =>
                mockUserRepository.login(emailWithSpecialChars, testPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(emailWithSpecialChars, testPassword);

        // Assert
        verify(() =>
                mockUserRepository.login(emailWithSpecialChars, testPassword))
            .called(1);
      });

      test('execute handles password with special characters', () async {
        // Arrange
        const passwordWithSpecialChars = 'P@ssw0rd!#\$%^&*()';
        when(() =>
                mockUserRepository.login(testEmail, passwordWithSpecialChars))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(testEmail, passwordWithSpecialChars);

        // Assert
        verify(() =>
                mockUserRepository.login(testEmail, passwordWithSpecialChars))
            .called(1);
      });
    });

    group('Authentication Error Cases', () {
      test('execute throws AuthException when repository throws AuthException',
          () async {
        // Arrange
        const authException = AuthException('Invalid credentials');
        when(() => mockUserRepository.login(invalidEmail, invalidPassword))
            .thenThrow(authException);

        // Act & Assert
        await expectLater(
          loginUseCase.execute(invalidEmail, invalidPassword),
          throwsA(isA<AuthException>()),
        );

        verify(() => mockUserRepository.login(invalidEmail, invalidPassword))
            .called(1);
      });

      test('execute throws specific AuthException message', () async {
        // Arrange
        const specificMessage =
            'Account locked due to multiple failed attempts';
        const authException = AuthException(specificMessage);
        when(() => mockUserRepository.login(testEmail, testPassword))
            .thenThrow(authException);

        // Act & Assert
        try {
          await loginUseCase.execute(testEmail, testPassword);
          fail('Expected AuthException to be thrown');
        } catch (e) {
          expect(e, isA<AuthException>());
          expect((e as AuthException).message, specificMessage);
        }

        verify(() => mockUserRepository.login(testEmail, testPassword))
            .called(1);
      });

      test('execute handles invalid email format gracefully', () async {
        // Arrange
        const invalidEmailFormat = 'not-an-email';
        const authException = AuthException('Invalid email format');
        when(() => mockUserRepository.login(invalidEmailFormat, testPassword))
            .thenThrow(authException);

        // Act & Assert
        await expectLater(
          loginUseCase.execute(invalidEmailFormat, testPassword),
          throwsA(isA<AuthException>()),
        );

        verify(() => mockUserRepository.login(invalidEmailFormat, testPassword))
            .called(1);
      });
    });

    group('Edge Cases and Validation', () {
      test('execute handles empty email', () async {
        // Arrange
        when(() => mockUserRepository.login(emptyEmail, testPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(emptyEmail, testPassword);

        // Assert
        verify(() => mockUserRepository.login(emptyEmail, testPassword))
            .called(1);
      });

      test('execute handles empty password', () async {
        // Arrange
        when(() => mockUserRepository.login(testEmail, emptyPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(testEmail, emptyPassword);

        // Assert
        verify(() => mockUserRepository.login(testEmail, emptyPassword))
            .called(1);
      });

      test('execute handles both empty email and password', () async {
        // Arrange
        when(() => mockUserRepository.login(emptyEmail, emptyPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(emptyEmail, emptyPassword);

        // Assert
        verify(() => mockUserRepository.login(emptyEmail, emptyPassword))
            .called(1);
      });

      test('execute handles very long email', () async {
        // Arrange
        final longEmail = '${'a' * 100}@${'domain' * 10}.com';
        when(() => mockUserRepository.login(longEmail, testPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(longEmail, testPassword);

        // Assert
        verify(() => mockUserRepository.login(longEmail, testPassword))
            .called(1);
      });

      test('execute handles very long password', () async {
        // Arrange
        final longPassword = 'P@ssw0rd!' * 20; // 180 characters
        when(() => mockUserRepository.login(testEmail, longPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(testEmail, longPassword);

        // Assert
        verify(() => mockUserRepository.login(testEmail, longPassword))
            .called(1);
      });
    });

    group('Network and System Error Cases', () {
      test('execute propagates generic exceptions from repository', () async {
        // Arrange
        final networkException = Exception('Network connection failed');
        when(() => mockUserRepository.login(testEmail, testPassword))
            .thenThrow(networkException);

        // Act & Assert
        await expectLater(
          loginUseCase.execute(testEmail, testPassword),
          throwsA(isA<Exception>()),
        );

        verify(() => mockUserRepository.login(testEmail, testPassword))
            .called(1);
      });

      test('execute propagates timeout exceptions', () async {
        // Arrange
        final timeoutException =
            TimeoutException('Request timeout', const Duration(seconds: 30));
        when(() => mockUserRepository.login(testEmail, testPassword))
            .thenThrow(timeoutException);

        // Act & Assert
        await expectLater(
          loginUseCase.execute(testEmail, testPassword),
          throwsA(isA<TimeoutException>()),
        );

        verify(() => mockUserRepository.login(testEmail, testPassword))
            .called(1);
      });

      test('execute handles repository returning null gracefully', () async {
        // Note: This tests the current implementation which returns void
        // If the repository were to return null in the future, this test would catch it
        when(() => mockUserRepository.login(testEmail, testPassword))
            .thenAnswer((_) async => Future.value());

        // Act & Assert
        await expectLater(
          loginUseCase.execute(testEmail, testPassword),
          completes,
        );

        verify(() => mockUserRepository.login(testEmail, testPassword))
            .called(1);
      });
    });

    group('Multiple Execution Cases', () {
      test('execute can be called multiple times with same credentials',
          () async {
        // Arrange
        when(() => mockUserRepository.login(testEmail, testPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(testEmail, testPassword);
        await loginUseCase.execute(testEmail, testPassword);
        await loginUseCase.execute(testEmail, testPassword);

        // Assert
        verify(() => mockUserRepository.login(testEmail, testPassword))
            .called(3);
      });

      test('execute can be called with different credentials', () async {
        // Arrange
        const email1 = 'user1@example.com';
        const email2 = 'user2@example.com';
        const password1 = 'password1';
        const password2 = 'password2';

        when(() => mockUserRepository.login(email1, password1))
            .thenAnswer((_) async => Future.value());
        when(() => mockUserRepository.login(email2, password2))
            .thenAnswer((_) async => Future.value());

        // Act
        await loginUseCase.execute(email1, password1);
        await loginUseCase.execute(email2, password2);

        // Assert
        verify(() => mockUserRepository.login(email1, password1)).called(1);
        verify(() => mockUserRepository.login(email2, password2)).called(1);
      });

      test('execute handles alternating success and failure', () async {
        // Arrange
        when(() => mockUserRepository.login(testEmail, testPassword))
            .thenAnswer((_) async => Future.value());
        when(() => mockUserRepository.login(invalidEmail, invalidPassword))
            .thenThrow(const AuthException('Invalid credentials'));

        // Act & Assert
        await expectLater(
          loginUseCase.execute(testEmail, testPassword),
          completes,
        );

        await expectLater(
          loginUseCase.execute(invalidEmail, invalidPassword),
          throwsA(isA<AuthException>()),
        );

        await expectLater(
          loginUseCase.execute(testEmail, testPassword),
          completes,
        );

        // Verify call counts
        verify(() => mockUserRepository.login(testEmail, testPassword))
            .called(2);
        verify(() => mockUserRepository.login(invalidEmail, invalidPassword))
            .called(1);
      });
    });

    group('Dependency Injection Tests', () {
      test('LoginUseCase requires UserRepository dependency', () {
        // This test verifies that the use case properly requires its dependency
        expect(
          () => LoginUseCase(userRepository: mockUserRepository),
          returnsNormally,
        );
      });

      test('LoginUseCase uses injected repository', () async {
        // Arrange
        final anotherMockRepository = MockUserRepository();
        final anotherUseCase =
            LoginUseCase(userRepository: anotherMockRepository);

        when(() => anotherMockRepository.login(testEmail, testPassword))
            .thenAnswer((_) async => Future.value());

        // Act
        await anotherUseCase.execute(testEmail, testPassword);

        // Assert - verify the correct repository was used
        verify(() => anotherMockRepository.login(testEmail, testPassword))
            .called(1);
        verifyZeroInteractions(
            mockUserRepository); // Original mock should not be called
      });
    });

    group('Performance and Concurrency Tests', () {
      test('execute can handle concurrent calls', () async {
        // Arrange
        when(() => mockUserRepository.login(any(), any())).thenAnswer(
            (_) async => Future.delayed(const Duration(milliseconds: 50)));

        // Act - make concurrent calls
        final futures = List.generate(
          5,
          (index) =>
              loginUseCase.execute('user$index@example.com', 'password$index'),
        );

        // Assert - all should complete
        await expectLater(
          Future.wait(futures),
          completes,
        );

        // Verify all calls were made
        verify(() => mockUserRepository.login(any(), any())).called(5);
      });

      test('execute preserves parameter integrity in concurrent calls',
          () async {
        // Arrange
        final List<String> capturedEmails = [];
        final List<String> capturedPasswords = [];

        when(() => mockUserRepository.login(any(), any()))
            .thenAnswer((invocation) async {
          capturedEmails.add(invocation.positionalArguments[0] as String);
          capturedPasswords.add(invocation.positionalArguments[1] as String);
          await Future.delayed(const Duration(milliseconds: 10));
        });

        // Act - make concurrent calls with different parameters
        final futures = [
          loginUseCase.execute('user1@example.com', 'password1'),
          loginUseCase.execute('user2@example.com', 'password2'),
          loginUseCase.execute('user3@example.com', 'password3'),
        ];

        await Future.wait(futures);

        // Assert - verify all unique parameters were captured
        expect(capturedEmails.length, 3);
        expect(capturedPasswords.length, 3);
        expect(capturedEmails.toSet().length, 3); // All unique emails
        expect(capturedPasswords.toSet().length, 3); // All unique passwords
      });
    });
  });
}
