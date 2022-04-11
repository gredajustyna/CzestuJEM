import 'package:czestujem/domain/usecases/add_food_usecase.dart';
import 'package:czestujem/domain/usecases/get_food_by_radius_usecase.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final AddFoodUseCase _addFoodUseCase;

  FoodBloc(this._addFoodUseCase) : super(FoodInitial()) {
    on<FoodEvent>((event, emit) async {
      if (event is AddFood) {
        await _handler(emit, event.foodToAdd!);
      }
    });
  }

  Future<void> _handler(Emitter<FoodState> emit, Map<String, dynamic> params) async {
    emit(FoodLoading());
    try{
      await _addFoodUseCase(params: params);
      emit(FoodDone());
    }catch(e){
      emit(FoodError());
    }
  }

}

class FoodByRadiusBloc extends Bloc<FoodEvent, FoodByRadiusState> {
  final GetFoodByRadiusUseCase _getFoodByRadiusUseCase;

  FoodByRadiusBloc(this._getFoodByRadiusUseCase) : super(FoodByRadiusInitial()) {
    on<FoodEvent>((event, emit) async {
      if (event is GetFoodByRadius) {
        await _radiusHandler(emit);
      }
    });
  }

  Future<void> _radiusHandler(Emitter<FoodByRadiusState> emit) async {
    emit(FoodByRadiusLoading());
    var result = await _getFoodByRadiusUseCase();
    if(result != null){
      emit(FoodByRadiusDone(result));
    }else{
      emit(FoodByRadiusError());
    }
  }
}