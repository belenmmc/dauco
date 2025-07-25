import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/usecases/get_all_minors_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class GetAllMinorsEvent {}

class GetEvent extends GetAllMinorsEvent {
  GetEvent();
}

class LoadMoreMinorsEvent extends GetAllMinorsEvent {
  final int page;

  LoadMoreMinorsEvent(this.page);

  int get getPage => page;
}

//states

abstract class GetAllMinorsState {}

class GetMinorsInitial extends GetAllMinorsState {}

class GetMinorsLoading extends GetAllMinorsState {}

class GetMinorsSuccess extends GetAllMinorsState {
  final List<Minor> minors;

  GetMinorsSuccess(this.minors);

  List<Minor> get getMinors => minors;
}

class GetAllMinorsError extends GetAllMinorsState {
  final String error;
  GetAllMinorsError({required this.error});
}

//bloc

class GetAllMinorsBloc extends Bloc<GetAllMinorsEvent, GetAllMinorsState> {
  final GetAllMinorsUseCase getAllMinorsUseCase;

  GetAllMinorsBloc({required this.getAllMinorsUseCase})
      : super(GetMinorsInitial()) {
    on<GetEvent>(_onGetEvent);
    on<LoadMoreMinorsEvent>(_onLoadMoreMinorsEvent);
  }

  void _onGetEvent(GetEvent event, Emitter<GetAllMinorsState> emit) async {
    emit(GetMinorsLoading());
    try {
      final minors = await getAllMinorsUseCase.execute(0);
      emit(GetMinorsSuccess(minors));
    } catch (e) {
      emit(GetAllMinorsError(error: e.toString()));
    }
  }

  void _onLoadMoreMinorsEvent(
      LoadMoreMinorsEvent event, Emitter<GetAllMinorsState> emit) async {
    emit(GetMinorsLoading());
    try {
      final minors = await getAllMinorsUseCase.execute(event.page);
      emit(GetMinorsSuccess(minors));
    } catch (e) {
      emit(GetAllMinorsError(error: e.toString()));
    }
  }
}
