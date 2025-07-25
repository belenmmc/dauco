import 'package:dauco/domain/entities/user_model.entity.dart';
import 'package:dauco/domain/usecases/update_user_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//events

abstract class UpdateEvent {}

class UpdateUserEvent extends UpdateEvent {
  final UserModel user;

  UpdateUserEvent({required this.user});
}

//states

abstract class UpdateUserState {}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {}

class UpdateUserError extends UpdateUserState {
  final String error;
  UpdateUserError({required this.error});
}

//bloc

class UpdateUserBloc extends Bloc<UpdateEvent, UpdateUserState> {
  UpdateUserUseCase updateUserUseCase;

  UpdateUserBloc({required this.updateUserUseCase})
      : super(UpdateUserInitial()) {
    on<UpdateUserEvent>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        await updateUserUseCase.execute(event.user);
        emit(UpdateUserSuccess());
      } on AuthException catch (e) {
        emit(UpdateUserError(error: e.toString()));
      }
    });
  }
}
