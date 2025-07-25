import 'package:dauco/domain/usecases/logout_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//events

abstract class UserLogoutEvent {}

class LogoutEvent extends UserLogoutEvent {
  LogoutEvent();
}

//states

abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutError extends LogoutState {
  final String error;
  LogoutError({required this.error});
}

//bloc

class LogoutBloc extends Bloc<UserLogoutEvent, LogoutState> {
  LogoutUseCase logoutUseCase;

  LogoutBloc({required this.logoutUseCase}) : super(LogoutInitial()) {
    on<LogoutEvent>((event, emit) async {
      emit(LogoutLoading());
      try {
        await logoutUseCase.execute();
        emit(LogoutSuccess());
      } on AuthException catch (e) {
        emit(LogoutError(error: e.toString()));
      }
    });
  }
}
