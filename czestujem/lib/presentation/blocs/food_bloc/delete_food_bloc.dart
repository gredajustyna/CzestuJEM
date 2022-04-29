import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/usecases/delete_food_usecase.dart';
import 'package:czestujem/presentation/blocs/food_bloc/delete_food_event.dart';
import 'package:czestujem/presentation/blocs/food_bloc/delete_food_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteFoodBloc extends Bloc<DeleteFoodEvent, DeleteFoodState> {
  final DeleteFoodUseCase _deleteFoodUseCase;

  DeleteFoodBloc(this._deleteFoodUseCase) : super(DeleteFoodInitial()) {
    on<DeleteFoodEvent>((event, emit) async {
      if (event is DeleteFood) {
        await _handler(emit, event.food!);
      }
    });
  }

  Future<void> _handler(Emitter<DeleteFoodState> emit, Food food) async {
    emit(DeleteFoodLoading());
    try{
      await _deleteFoodUseCase(params: food);
      emit(DeleteFoodDone());
    }catch(e){
      emit(DeleteFoodError());
    }
  }

}