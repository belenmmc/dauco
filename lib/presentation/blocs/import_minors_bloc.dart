import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/usecases/import_minors_use_case.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class ImportMinorsEvent {}

class ImportEvent extends ImportMinorsEvent {
  final Excel file;

  ImportEvent(this.file);

  Excel get getFile => file;
}

class LoadMoreMinorsEvent extends ImportMinorsEvent {
  final Excel file;
  final int page;

  LoadMoreMinorsEvent(this.file, this.page);

  Excel get getFile => file;

  int get getPage => page;
}

//states

abstract class ImportMinorsState {}

class ImportMinorsInitial extends ImportMinorsState {}

class ImportMinorsLoading extends ImportMinorsState {}

class ImportMinorsSuccess extends ImportMinorsState {
  final List<Minor> minors;

  ImportMinorsSuccess(this.minors);

  List<Minor> get getMinors => minors;
}

class ImportMinorsError extends ImportMinorsState {
  final String error;
  ImportMinorsError({required this.error});
}

//bloc

class ImportMinorsBloc extends Bloc<ImportMinorsEvent, ImportMinorsState> {
  final ImportMinorsUseCase importMinorsUseCase;

  ImportMinorsBloc({required this.importMinorsUseCase})
      : super(ImportMinorsInitial()) {
    on<ImportEvent>(_onImportEvent);
    on<LoadMoreMinorsEvent>(_onLoadMoreMinorsEvent);
  }

  void _onImportEvent(
      ImportEvent event, Emitter<ImportMinorsState> emit) async {
    emit(ImportMinorsLoading());
    try {
      final minors = await importMinorsUseCase.execute(event.file, page: 1);
      emit(ImportMinorsSuccess(minors));
    } catch (e) {
      emit(ImportMinorsError(error: e.toString()));
    }
  }

  void _onLoadMoreMinorsEvent(
      LoadMoreMinorsEvent event, Emitter<ImportMinorsState> emit) async {
    emit(ImportMinorsLoading());
    try {
      final minors =
          await importMinorsUseCase.execute(event.file, page: event.page);
      emit(ImportMinorsSuccess(minors));
    } catch (e) {
      emit(ImportMinorsError(error: e.toString()));
    }
  }
}
