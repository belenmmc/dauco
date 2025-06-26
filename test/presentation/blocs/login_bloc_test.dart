import 'package:dauco/presentation/blocs/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:dauco/domain/usecases/login_use_case.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks([LoginUseCase])
void main() {
  late MockLoginUseCase mockLoginUseCase;
  late LoginBloc loginBloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(loginUseCase: mockLoginUseCase);
  });
  group('LoginBloc', () {
    test('initial state is LoginInitial', () {
      expect(loginBloc.state, isA<LoginInitial>());
    });

    test('initial state is LoginInitial', () {
      expect(loginBloc.state, isA<LoginInitial>());
    });

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] when login is successful',
      build: () {
        when(mockLoginUseCase.execute(any, any)).thenAnswer((_) async => null);
        return loginBloc;
      },
      act: (bloc) => bloc
          .add(LoginEvent(email: 'test@example.com', password: 'password123')),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] when AuthException is thrown',
      build: () {
        when(mockLoginUseCase.execute(any, any)).thenThrow(
          const AuthException('Invalid credentials'),
        );
        return loginBloc;
      },
      act: (bloc) => bloc
          .add(LoginEvent(email: 'wrong@example.com', password: 'wrongpass')),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginError>()
            .having((e) => e.error, 'error', contains('Invalid credentials')),
      ],
    );
  });
}
