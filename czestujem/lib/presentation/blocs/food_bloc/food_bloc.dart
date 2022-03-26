import 'package:czestujem/domain/usecases/add_food_usecase.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState>{
  final AddFoodUseCase _addFoodUseCase;
  FoodBloc(this._addFoodUseCase) : super(FoodInitial()){
    on<FoodEvent>((event, emit) async {
      if(event is AddFood){
        await _handler(emit, event.foodToAdd!);
      }
    });
  }

  Future<void> _handler(Emitter<FoodState> emit, Map<String, dynamic> params) async {
    emit(FoodLoading());
    var result = await _addFoodUseCase(params: params);
    if(result != null){
      emit(FoodDone());
    }else{
      emit(FoodError());
    }
  }
  Future<void> _radiusHandler(Emitter<FoodState> emit, void params) async {
    emit(FoodLoading());
    var result = await _addFoodUseCase(params: params);
    if(result != null){
      emit(FoodDone());
    }else{
      emit(FoodError());
    }
  }

}