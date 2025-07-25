import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/domain/usecases/get_all_tests_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class GetAllTestsEvent {
  int minorId;

  GetAllTestsEvent(this.minorId);

  int get getMinorId => minorId;
}

class GetEvent extends GetAllTestsEvent {
  GetEvent(super.minorId);
}

//states

abstract class GetTestsState {}

class GetTestsInitial extends GetTestsState {}

class GetTestsLoading extends GetTestsState {}

class GetTestsSuccess extends GetTestsState {
  final List<Test> tests;

  GetTestsSuccess(this.tests);

  List<Test> get getTests => tests;
}

class GetTestsError extends GetTestsState {
  final String error;
  GetTestsError({required this.error});
}

//bloc

class GetTestsBloc extends Bloc<GetAllTestsEvent, GetTestsState> {
  final GetAllTestsUseCase getAllTestsUseCase;

  GetTestsBloc({required this.getAllTestsUseCase}) : super(GetTestsInitial()) {
    on<GetAllTestsEvent>((event, emit) async {
      emit(GetTestsLoading());
      try {
        final tests = await getAllTestsUseCase.execute(event.minorId);
        emit(GetTestsSuccess(tests));
      } catch (e) {
        emit(GetTestsError(error: e.toString()));
      }
    });
  }
}
