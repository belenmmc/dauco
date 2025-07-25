import 'package:dauco/domain/entities/user_model.entity.dart';
import 'package:dauco/domain/usecases/get_current_user_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class GetCurrentUserEvent {
  GetCurrentUserEvent();
}

class GetUserEvent extends GetCurrentUserEvent {
  GetUserEvent();
}

//states

abstract class GetCurrentUserState {}

class GetCurrentUserInitial extends GetCurrentUserState {}

class GetCurrentUserLoading extends GetCurrentUserState {}

class GetCurrentUserSuccess extends GetCurrentUserState {
  final UserModel currentUser;

  GetCurrentUserSuccess(this.currentUser);

  UserModel get getCurrentUser => currentUser;
}

class GetCurrentUserError extends GetCurrentUserState {
  final String error;
  GetCurrentUserError({required this.error});
}

//bloc

class GetCurrentUserBloc
    extends Bloc<GetCurrentUserEvent, GetCurrentUserState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  GetCurrentUserBloc({required this.getCurrentUserUseCase})
      : super(GetCurrentUserInitial()) {
    on<GetCurrentUserEvent>((event, emit) async {
      emit(GetCurrentUserLoading());
      try {
        final currentUser = await getCurrentUserUseCase.execute();
        emit(GetCurrentUserSuccess(currentUser));
      } catch (e) {
        emit(GetCurrentUserError(error: e.toString()));
      }
    });
  }
}
