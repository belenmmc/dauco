import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/usecases/update_minor_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//events

abstract class UpdateEvent {}

class UpdateMinorEvent extends UpdateEvent {
  final Minor minor;

  UpdateMinorEvent({required this.minor});
}

//states

abstract class UpdateMinorState {}

class UpdateMinorInitial extends UpdateMinorState {}

class UpdateMinorLoading extends UpdateMinorState {}

class UpdateMinorSuccess extends UpdateMinorState {}

class UpdateMinorError extends UpdateMinorState {
  final String error;
  UpdateMinorError({required this.error});
}

//bloc

class UpdateMinorBloc extends Bloc<UpdateEvent, UpdateMinorState> {
  UpdateMinorUseCase updateMinorUseCase;

  UpdateMinorBloc({required this.updateMinorUseCase})
      : super(UpdateMinorInitial()) {
    on<UpdateMinorEvent>((event, emit) async {
      emit(UpdateMinorLoading());
      try {
        await updateMinorUseCase.execute(event.minor);
        emit(UpdateMinorSuccess());
      } on AuthException catch (e) {
        emit(UpdateMinorError(error: e.toString()));
      }
    });
  }
}
