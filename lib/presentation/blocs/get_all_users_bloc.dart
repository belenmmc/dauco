import 'package:dauco/domain/entities/user_model.entity.dart';
import 'package:dauco/domain/usecases/get_all_users_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class GetAllUsersEvent {}

class GetEvent extends GetAllUsersEvent {
  GetEvent();
}

class LoadMoreUsersEvent extends GetAllUsersEvent {
  final int page;
  final String? filterName;
  final String? filterEmail;
  final String? filterRole;
  final String? filterManagerId;

  LoadMoreUsersEvent(
    this.page, {
    this.filterName,
    this.filterEmail,
    this.filterRole,
    this.filterManagerId,
  });

  int get getPage => page;
}

//states

abstract class GetAllUsersState {}

class GetUsersInitial extends GetAllUsersState {}

class GetUsersLoading extends GetAllUsersState {}

class GetUsersSuccess extends GetAllUsersState {
  final List<UserModel> users;

  GetUsersSuccess(this.users);

  List<UserModel> get getUsers => users;
}

class GetAllUsersError extends GetAllUsersState {
  final String error;
  GetAllUsersError({required this.error});
}

//bloc

class GetAllUsersBloc extends Bloc<GetAllUsersEvent, GetAllUsersState> {
  final GetAllUsersUseCase getAllUsersUseCase;

  GetAllUsersBloc({required this.getAllUsersUseCase})
      : super(GetUsersInitial()) {
    on<GetEvent>(_onGetEvent);
    on<LoadMoreUsersEvent>(_onLoadMoreUsersEvent);
  }

  void _onGetEvent(GetEvent event, Emitter<GetAllUsersState> emit) async {
    emit(GetUsersLoading());
    try {
      final users = await getAllUsersUseCase.execute(0);
      emit(GetUsersSuccess(users));
    } catch (e) {
      emit(GetAllUsersError(error: e.toString()));
      print('Error fetching users: $e');
    }
  }

  void _onLoadMoreUsersEvent(
      LoadMoreUsersEvent event, Emitter<GetAllUsersState> emit) async {
    emit(GetUsersLoading());
    try {
      final users = await getAllUsersUseCase.execute(
        event.page,
        filterName: event.filterName,
        filterEmail: event.filterEmail,
        filterRole: event.filterRole,
        filterManagerId: event.filterManagerId,
      );
      emit(GetUsersSuccess(users));
    } catch (e) {
      emit(GetAllUsersError(error: e.toString()));
    }
  }
}
