import 'package:dauco/domain/usecases/load_file_use_case.dart';
import 'package:dauco/domain/usecases/pick_file_use_case.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class LoadEvent {}

class LoadFileEvent extends LoadEvent {
  final BuildContext context;

  LoadFileEvent(this.context);
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

class LoadFileCompleted extends LoadFileState {
  final Map<String, Map<String, int>> importResults;

  LoadFileCompleted(this.importResults);

  Map<String, Map<String, int>> get getImportResults => importResults;
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
      print('LoadFileEvent triggered');
      emit(LoadFileLoading());
      try {
        final file = await pickFileUseCase.execute();
        if (file != null) {
          print('File picked successfully, emitting LoadFileSuccess');
          emit(LoadFileSuccess(file));
          print('Starting file import process...');
          final importResults = await loadFileUseCase.execute(file, (progress) {
            print('Import progress: ${(progress * 100).toStringAsFixed(0)}%');
          }, event.context);
          print('Import completed with results: $importResults');
          emit(LoadFileCompleted(importResults));
        } else {
          print('File picker was cancelled');
          emit(LoadFileCancelled());
        }
      } catch (e) {
        print('LoadFileEvent error: ${e.toString()}');
        emit(LoadFileError(error: e.toString()));
      }
    });
  }
}
