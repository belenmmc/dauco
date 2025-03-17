import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/usecases/get_minors_use_case.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class GetMinorsEvent {}

class GetEvent extends GetMinorsEvent {
  final Excel file;

  GetEvent(this.file);

  Excel get getFile => file;
}

class LoadMoreMinorsEvent extends GetMinorsEvent {
  final Excel file;
  final int page;

  LoadMoreMinorsEvent(this.file, this.page);

  Excel get getFile => file;

  int get getPage => page;
}

//states

abstract class GetMinorsState {}

class GetMinorsInitial extends GetMinorsState {}

class GetMinorsLoading extends GetMinorsState {}

class GetMinorsSuccess extends GetMinorsState {
  final List<Minor> minors;

  GetMinorsSuccess(this.minors);

  List<Minor> get getMinors => minors;
}

class GetMinorsError extends GetMinorsState {
  final String error;
  GetMinorsError({required this.error});
}

//bloc

class GetMinorsBloc extends Bloc<GetMinorsEvent, GetMinorsState> {
  final GetMinorsUseCase importMinorsUseCase;

  GetMinorsBloc({required this.importMinorsUseCase})
      : super(GetMinorsInitial()) {
    on<GetEvent>(_onGetEvent);
    on<LoadMoreMinorsEvent>(_onLoadMoreMinorsEvent);
  }

  void _onGetEvent(GetEvent event, Emitter<GetMinorsState> emit) async {
    emit(GetMinorsLoading());
    try {
      final minors = await importMinorsUseCase.execute(event.file, page: 1);
      emit(GetMinorsSuccess(minors));
    } catch (e) {
      emit(GetMinorsError(error: e.toString()));
    }
  }

  void _onLoadMoreMinorsEvent(
      LoadMoreMinorsEvent event, Emitter<GetMinorsState> emit) async {
    emit(GetMinorsLoading());
    try {
      final minors =
          await importMinorsUseCase.execute(event.file, page: event.page);
      emit(GetMinorsSuccess(minors));
    } catch (e) {
      emit(GetMinorsError(error: e.toString()));
    }
  }
}
