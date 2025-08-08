import 'package:dauco/domain/usecases/delete_minor_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//events

abstract class DeleteEvent {}

class DeleteMinorEvent extends DeleteEvent {
  final String minorId;

  DeleteMinorEvent({required this.minorId});
}

//states

abstract class DeleteMinorState {}

class DeleteMinorInitial extends DeleteMinorState {}

class DeleteMinorLoading extends DeleteMinorState {}

class DeleteMinorSuccess extends DeleteMinorState {}

class DeleteMinorError extends DeleteMinorState {
  final String error;
  DeleteMinorError({required this.error});
}

//bloc

class DeleteMinorBloc extends Bloc<DeleteEvent, DeleteMinorState> {
  DeleteMinorUseCase deleteMinorUseCase;

  DeleteMinorBloc({required this.deleteMinorUseCase})
      : super(DeleteMinorInitial()) {
    on<DeleteMinorEvent>((event, emit) async {
      emit(DeleteMinorLoading());
      try {
        await deleteMinorUseCase.execute(event.minorId);
        emit(DeleteMinorSuccess());
      } on AuthException catch (e) {
        emit(DeleteMinorError(error: e.toString()));
      }
    });
  }
}
