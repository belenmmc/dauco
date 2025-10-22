import 'package:dauco/domain/usecases/reset_password_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//events

abstract class ResetPasswordEvent {}

class ResetPasswordRequestEvent extends ResetPasswordEvent {
  final String email;

  ResetPasswordRequestEvent({required this.email});
}

//states

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String error;
  ResetPasswordError({required this.error});
}

//bloc

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordUseCase resetPasswordUseCase;

  ResetPasswordBloc({required this.resetPasswordUseCase})
      : super(ResetPasswordInitial()) {
    on<ResetPasswordRequestEvent>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        await resetPasswordUseCase.execute(event.email);
        emit(ResetPasswordSuccess());
      } on AuthException catch (e) {
        emit(ResetPasswordError(error: e.toString()));
      } catch (e) {
        emit(ResetPasswordError(error: e.toString()));
      }
    });
  }
}
