import 'package:dauco/domain/usecases/delete_user_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//events

abstract class DeleteEvent {}

class DeleteUserEvent extends DeleteEvent {
  final String email;

  DeleteUserEvent({required this.email});
}

//states

abstract class DeleteUserState {}

class DeleteUserInitial extends DeleteUserState {}

class DeleteUserLoading extends DeleteUserState {}

class DeleteUserSuccess extends DeleteUserState {}

class DeleteUserError extends DeleteUserState {
  final String error;
  DeleteUserError({required this.error});
}

//bloc

class DeleteUserBloc extends Bloc<DeleteEvent, DeleteUserState> {
  DeleteUserUseCase deleteUserUseCase;

  DeleteUserBloc({required this.deleteUserUseCase})
      : super(DeleteUserInitial()) {
    on<DeleteUserEvent>((event, emit) async {
      emit(DeleteUserLoading());
      try {
        await deleteUserUseCase.execute(event.email);
        emit(DeleteUserSuccess());
      } on AuthException catch (e) {
        emit(DeleteUserError(error: e.toString()));
      }
    });
  }
}
