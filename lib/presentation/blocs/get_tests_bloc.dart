import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/domain/usecases/get_tests_use_case.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class GetTestsEvent {
  final Excel file;
  int minorId;

  GetTestsEvent(this.file, this.minorId);

  int get getMinorId => minorId;
  Excel get getFile => file;
}

class GetEvent extends GetTestsEvent {
  GetEvent(super.file, super.minorId);
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

class GetTestsBloc extends Bloc<GetTestsEvent, GetTestsState> {
  final GetTestsUseCase getTestsUseCase;

  GetTestsBloc({required this.getTestsUseCase}) : super(GetTestsInitial()) {
    on<GetTestsEvent>((event, emit) async {
      emit(GetTestsLoading());
      try {
        final tests = await getTestsUseCase.execute(event.file, event.minorId);
        emit(GetTestsSuccess(tests));
      } catch (e) {
        emit(GetTestsError(error: e.toString()));
      }
    });
  }
}
