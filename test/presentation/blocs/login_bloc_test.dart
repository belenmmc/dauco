import 'package:dauco/domain/usecases/login_use_case.dart';
import 'package:dauco/presentation/blocs/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock classes
class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc Tests', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const invalidEmail = 'invalid@example.com';
    const invalidPassword = 'wrongpassword';

    test('initial state should be LoginInitial', () {
      expect(loginBloc.state, isA<LoginInitial>());
    });

    group('LoginEvent Tests', () {
      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, LoginSuccess] when login is successful',
        build: () {
          when(() => mockLoginUseCase.execute(testEmail, testPassword))
              .thenAnswer((_) async => Future.value());
          return loginBloc;
        },
        act: (bloc) =>
            bloc.add(LoginEvent(email: testEmail, password: testPassword)),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginSuccess>(),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase.execute(testEmail, testPassword))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, LoginError] when login fails with AuthException',
        build: () {
          when(() => mockLoginUseCase.execute(invalidEmail, invalidPassword))
              .thenThrow(const AuthException('Invalid credentials'));
          return loginBloc;
        },
        act: (bloc) => bloc
            .add(LoginEvent(email: invalidEmail, password: invalidPassword)),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>(),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase.execute(invalidEmail, invalidPassword))
              .called(1);
        },
      );

      // Note: The actual LoginBloc implementation only catches AuthException
      // Generic exceptions would cause uncaught errors in the real app

      blocTest<LoginBloc, LoginState>(
        'LoginError contains correct error message for AuthException',
        build: () {
          when(() => mockLoginUseCase.execute(invalidEmail, invalidPassword))
              .thenThrow(const AuthException('Invalid credentials'));
          return loginBloc;
        },
        act: (bloc) => bloc
            .add(LoginEvent(email: invalidEmail, password: invalidPassword)),
        expect: () => [
          isA<LoginLoading>(),
          predicate<LoginError>((state) =>
              state.error == "Credenciales incorrectas. Inténtelo de nuevo.")
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'handles multiple login attempts correctly',
        build: () {
          when(() => mockLoginUseCase.execute(testEmail, testPassword))
              .thenAnswer((_) async => Future.value());
          return loginBloc;
        },
        act: (bloc) {
          bloc.add(LoginEvent(email: testEmail, password: testPassword));
          bloc.add(LoginEvent(email: testEmail, password: testPassword));
        },
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginSuccess>(),
          isA<LoginLoading>(),
          isA<LoginSuccess>(),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase.execute(testEmail, testPassword))
              .called(2);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'handles empty email and password',
        build: () {
          when(() => mockLoginUseCase.execute('', ''))
              .thenThrow(const AuthException('Empty credentials'));
          return loginBloc;
        },
        act: (bloc) => bloc.add(LoginEvent(email: '', password: '')),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>(),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase.execute('', '')).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'handles only email provided (empty password)',
        build: () {
          when(() => mockLoginUseCase.execute(testEmail, ''))
              .thenThrow(const AuthException('Empty password'));
          return loginBloc;
        },
        act: (bloc) => bloc.add(LoginEvent(email: testEmail, password: '')),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>(),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase.execute(testEmail, '')).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'handles only password provided (empty email)',
        build: () {
          when(() => mockLoginUseCase.execute('', testPassword))
              .thenThrow(const AuthException('Empty email'));
          return loginBloc;
        },
        act: (bloc) => bloc.add(LoginEvent(email: '', password: testPassword)),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>(),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase.execute('', testPassword)).called(1);
        },
      );
    });

    group('LoginEvent Equality Tests', () {
      test('LoginEvent equality works correctly', () {
        final event1 = LoginEvent(email: testEmail, password: testPassword);
        final event2 = LoginEvent(email: testEmail, password: testPassword);
        final event3 = LoginEvent(email: invalidEmail, password: testPassword);

        // Note: Since LoginEvent doesn't override equality, these will be different instances
        expect(event1, isNot(equals(event2)));
        expect(event1, isNot(equals(event3)));
      });

      test('LoginEvent properties are accessible', () {
        final event = LoginEvent(email: testEmail, password: testPassword);
        expect(event.email, testEmail);
        expect(event.password, testPassword);
      });
    });

    group('LoginState Tests', () {
      test('LoginError state contains error message', () {
        const errorMessage = 'Test error message';
        final errorState = LoginError(error: errorMessage);
        expect(errorState.error, errorMessage);
      });

      test('All states are different types', () {
        final initialState = LoginInitial();
        final loadingState = LoginLoading();
        final successState = LoginSuccess();
        final errorState = LoginError(error: 'error');

        expect(initialState, isA<LoginInitial>());
        expect(loadingState, isA<LoginLoading>());
        expect(successState, isA<LoginSuccess>());
        expect(errorState, isA<LoginError>());

        // Verify they're different types
        expect(initialState, isNot(isA<LoginLoading>()));
        expect(loadingState, isNot(isA<LoginSuccess>()));
        expect(successState, isNot(isA<LoginError>()));
        expect(errorState, isNot(isA<LoginInitial>()));
      });
    });

    group('Edge Cases and Integration Tests', () {
      blocTest<LoginBloc, LoginState>(
        'transitions from success back to loading on new event',
        build: () {
          when(() => mockLoginUseCase.execute(testEmail, testPassword))
              .thenAnswer((_) async => Future.value());
          return loginBloc;
        },
        act: (bloc) {
          bloc.add(LoginEvent(email: testEmail, password: testPassword));
          // Wait for success then add another event
          bloc.add(LoginEvent(email: testEmail, password: testPassword));
        },
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginSuccess>(),
          isA<LoginLoading>(),
          isA<LoginSuccess>(),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'transitions from error back to loading on new event',
        build: () {
          // First call fails
          when(() => mockLoginUseCase.execute(invalidEmail, invalidPassword))
              .thenThrow(const AuthException('Invalid credentials'));
          // Second call succeeds
          when(() => mockLoginUseCase.execute(testEmail, testPassword))
              .thenAnswer((_) async => Future.value());
          return loginBloc;
        },
        act: (bloc) {
          bloc.add(LoginEvent(email: invalidEmail, password: invalidPassword));
          bloc.add(LoginEvent(email: testEmail, password: testPassword));
        },
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>(),
          isA<LoginLoading>(),
          isA<LoginSuccess>(),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'handles rapid successive events (events may process concurrently)',
        build: () {
          when(() => mockLoginUseCase.execute(any(), any())).thenAnswer(
              (_) async => Future.delayed(const Duration(milliseconds: 50)));
          return loginBloc;
        },
        act: (bloc) {
          // Add multiple events quickly - they will process concurrently
          bloc.add(LoginEvent(email: testEmail, password: testPassword));
          bloc.add(LoginEvent(email: testEmail, password: testPassword));
          bloc.add(LoginEvent(email: testEmail, password: testPassword));
        },
        wait: const Duration(milliseconds: 200),
        expect: () => [
          // Multiple LoadingStates may be emitted as events process concurrently
          isA<LoginLoading>(),
          isA<LoginLoading>(),
          isA<LoginLoading>(),
          isA<LoginSuccess>(),
          isA<LoginSuccess>(),
          isA<LoginSuccess>(),
        ],
      );

      test('bloc can be closed without errors', () {
        expect(() => loginBloc.close(), returnsNormally);
      });
    });

    group('Use Case Integration Tests', () {
      blocTest<LoginBloc, LoginState>(
        'use case is called with correct parameters',
        build: () {
          when(() => mockLoginUseCase.execute(any(), any()))
              .thenAnswer((_) async => Future.value());
          return loginBloc;
        },
        act: (bloc) =>
            bloc.add(LoginEvent(email: testEmail, password: testPassword)),
        verify: (_) {
          verify(() => mockLoginUseCase.execute(testEmail, testPassword))
              .called(1);
          verifyNoMoreInteractions(mockLoginUseCase);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'use case is not called again after previous failure',
        build: () {
          when(() => mockLoginUseCase.execute(invalidEmail, invalidPassword))
              .thenThrow(const AuthException('Invalid credentials'));
          return loginBloc;
        },
        act: (bloc) => bloc
            .add(LoginEvent(email: invalidEmail, password: invalidPassword)),
        verify: (_) {
          verify(() => mockLoginUseCase.execute(invalidEmail, invalidPassword))
              .called(1);
          verifyNoMoreInteractions(mockLoginUseCase);
        },
      );
    });
  });
}
