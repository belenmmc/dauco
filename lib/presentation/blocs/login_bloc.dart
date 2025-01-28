//events

import 'package:dauco/domain/usercases/login_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserLoginEvent {}

class LoginEvent extends UserLoginEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

//states

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}

//bloc

class LoginBloc extends Bloc<UserLoginEvent, LoginState> {
  LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        await loginUseCase.execute(event.email, event.password);
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginError(error: e.toString()));
      }
    });
  }
}
