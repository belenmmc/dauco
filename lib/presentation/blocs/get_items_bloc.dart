import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/usecases/get_items_use_case.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class GetItemsEvent {
  final Excel file;
  int testId;

  GetItemsEvent(this.file, this.testId);

  int get getTestId => testId;
  Excel get getFile => file;
}

class GetEvent extends GetItemsEvent {
  GetEvent(super.file, super.testId);
}

//states

abstract class GetItemsState {}

class GetItemsInitial extends GetItemsState {}

class GetItemsLoading extends GetItemsState {}

class GetItemsSuccess extends GetItemsState {
  final List<Item> items;

  GetItemsSuccess(this.items);

  List<Item> get getItems => items;
}

class GetItemsError extends GetItemsState {
  final String error;
  GetItemsError({required this.error});
}

//bloc

class GetItemsBloc extends Bloc<GetItemsEvent, GetItemsState> {
  final GetItemsUseCase getItemsUseCase;

  GetItemsBloc({required this.getItemsUseCase}) : super(GetItemsInitial()) {
    on<GetItemsEvent>((event, emit) async {
      emit(GetItemsLoading());
      try {
        final items = await getItemsUseCase.execute(event.file, event.testId);
        emit(GetItemsSuccess(items));
      } catch (e) {
        emit(GetItemsError(error: e.toString()));
      }
    });
  }
}
