import 'package:czestujem/domain/usecases/get_my_food_usecase.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_event.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetFridgeBloc extends Bloc<FridgeEvent, FridgeState>{
  final GetMyFoodUseCase _getMyFoodUseCase;
  GetFridgeBloc(this._getMyFoodUseCase) : super(FridgeInitial()){
    on<FridgeEvent>((event, emit) async {
      if(event is GetMyFridge){
        await _fridgeHandler(emit, event.uid!);
      }
    });
  }

  Future<void> _fridgeHandler(Emitter<FridgeState> emit, String params) async {
    emit(FridgeLoading());
    var result = await _getMyFoodUseCase(params: params);
    if(result != null){
      emit(FridgeDone(result));
    }else{
      emit(FridgeError());
    }
  }
}