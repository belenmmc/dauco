import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/usecases/import_users_use_case.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class ImportUsersEvent {}

class ImportEvent extends ImportUsersEvent {
  final Excel file;

  ImportEvent(this.file);

  Excel get getFile => file;
}

class LoadMoreUsersEvent extends ImportUsersEvent {
  final Excel file;
  final int page;

  LoadMoreUsersEvent(this.file, this.page);

  Excel get getFile => file;

  int get getPage => page;
}

//states

abstract class ImportUsersState {}

class ImportUsersInitial extends ImportUsersState {}

class ImportUsersLoading extends ImportUsersState {}

class ImportUsersSuccess extends ImportUsersState {
  final List<ImportedUser> users;

  ImportUsersSuccess(this.users);

  List<ImportedUser> get getUsers => users;
}

class ImportUsersError extends ImportUsersState {
  final String error;
  ImportUsersError({required this.error});
}

//bloc

class ImportUsersBloc extends Bloc<ImportUsersEvent, ImportUsersState> {
  final ImportUsersUseCase importUsersUseCase;

  ImportUsersBloc({required this.importUsersUseCase})
      : super(ImportUsersInitial()) {
    on<ImportEvent>(_onImportEvent);
    on<LoadMoreUsersEvent>(_onLoadMoreUsersEvent);
  }

  void _onImportEvent(ImportEvent event, Emitter<ImportUsersState> emit) async {
    emit(ImportUsersLoading());
    try {
      final users = await importUsersUseCase.execute(event.file, page: 1);
      emit(ImportUsersSuccess(users));
    } catch (e) {
      emit(ImportUsersError(error: e.toString()));
    }
  }

  void _onLoadMoreUsersEvent(
      LoadMoreUsersEvent event, Emitter<ImportUsersState> emit) async {
    emit(ImportUsersLoading());
    try {
      final users =
          await importUsersUseCase.execute(event.file, page: event.page);
      emit(ImportUsersSuccess(users));
    } catch (e) {
      emit(ImportUsersError(error: e.toString()));
    }
  }
}
