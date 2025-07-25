import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/usecases/get_all_items_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class GetItemsEvent {
  int testId;

  GetItemsEvent(this.testId);

  int get getTestId => testId;
}

class GetEvent extends GetItemsEvent {
  GetEvent(super.testId);
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
  final GetAllItemsUseCase getItemsUseCase;

  GetItemsBloc({required this.getItemsUseCase}) : super(GetItemsInitial()) {
    on<GetItemsEvent>((event, emit) async {
      emit(GetItemsLoading());
      try {
        final items = await getItemsUseCase.execute(event.testId);
        emit(GetItemsSuccess(items));
      } catch (e) {
        emit(GetItemsError(error: e.toString()));
      }
    });
  }
}
