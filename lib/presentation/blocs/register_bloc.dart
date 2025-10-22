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
  final String role;

  RegisterEvent(
      {required this.email,
      required this.password,
      required this.managerId,
      required this.name,
      required this.role});
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
        await registerUseCase.execute(event.email, event.password,
            event.managerId, event.name, event.role);
        emit(RegisterSuccess());
      } on PostgrestException catch (e) {
        if (e.code == '23505' ||
            e.message.contains('duplicate') ||
            e.message.contains('unique')) {
          if (e.message.contains('email') ||
              e.message.contains('usuarios_email_key')) {
            emit(RegisterError(
                error: 'Ya existe un usuario con el email: ${event.email}'));
          } else if (e.message.contains('manager_id') ||
              e.message.contains('usuarios_manager_id_key')) {
            emit(RegisterError(
                error:
                    'Ya existe un usuario con el ID de responsable: ${event.managerId}'));
          } else {
            emit(RegisterError(
                error:
                    'Ya existe un usuario con estos datos. Verifica el email o ID de responsable.'));
          }
        } else {
          emit(RegisterError(error: 'Error de base de datos: ${e.message}'));
        }
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.contains('Ya existe un usuario con el email:')) {
          emit(RegisterError(error: errorMessage));
        } else if (errorMessage
            .contains('Ya existe un usuario con el ID de responsable:')) {
          emit(RegisterError(error: errorMessage));
        } else {
          emit(RegisterError(error: 'Error creando usuario: $errorMessage'));
        }
      }
    });
  }
}
