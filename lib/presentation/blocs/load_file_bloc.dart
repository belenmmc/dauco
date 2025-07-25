import 'package:dauco/domain/usecases/load_file_use_case.dart';
import 'package:dauco/domain/usecases/pick_file_use_case.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class LoadEvent {}

class LoadFileEvent extends LoadEvent {
  LoadFileEvent();
}

//states

abstract class LoadFileState {}

class LoadFileInitial extends LoadFileState {}

class LoadFileLoading extends LoadFileState {}

class LoadFileSuccess extends LoadFileState {
  final Excel file;

  LoadFileSuccess(this.file);

  Excel get getFile => file;
}

class LoadFileCancelled extends LoadFileState {}

class LoadFileError extends LoadFileState {
  final String error;
  LoadFileError({required this.error});
}

//bloc

class LoadFileBloc extends Bloc<LoadEvent, LoadFileState> {
  PickFileUseCase pickFileUseCase;
  LoadFileUseCase loadFileUseCase;

  LoadFileBloc({required this.loadFileUseCase, required this.pickFileUseCase})
      : super(LoadFileInitial()) {
    on<LoadFileEvent>((event, emit) async {
      emit(LoadFileLoading());
      try {
        final file = await pickFileUseCase.execute();
        if (file != null) {
          emit(LoadFileSuccess(file));
          await loadFileUseCase.execute(file, (progress) {
            print('Progreso: ${(progress * 100).toStringAsFixed(0)}%');
          });
        } else {
          emit(LoadFileCancelled());
        }
      } catch (e) {
        emit(LoadFileError(error: e.toString()));
      }
    });
  }
}
