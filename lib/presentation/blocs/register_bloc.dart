import 'package:dauco/domain/usecases/register_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//events

abstract class RegisterUserEvent {}

class RegisterEvent extends RegisterUserEvent {
  final String email;
  final String password;
  final int managerId;
  final String name;

  RegisterEvent(
      {required this.email,
      required this.password,
      required this.managerId,
      required this.name});
}

//states

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String error;
  RegisterError({required this.error});
}

//bloc

class RegisterBloc extends Bloc<RegisterUserEvent, RegisterState> {
  RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        await registerUseCase.execute(
            event.email, event.password, event.managerId, event.name);
        emit(RegisterSuccess());
      } on AuthException catch (e) {
        emit(RegisterError(error: e.toString()));
      }
    });
  }
}
