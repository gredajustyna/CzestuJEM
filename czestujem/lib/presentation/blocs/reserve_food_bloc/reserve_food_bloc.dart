import 'package:czestujem/domain/usecases/reserve_food_usecase.dart';
import 'package:czestujem/presentation/blocs/reserve_food_bloc/reserve_food_event.dart';
import 'package:czestujem/presentation/blocs/reserve_food_bloc/reserve_food_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveFoodBloc extends Bloc<ReserveFoodEvent, ReserveFoodState>{
  final ReserveFoodUseCase _reserveFoodUseCase;
  ReserveFoodBloc(this._reserveFoodUseCase) : super(ReserveFoodInitial()){
    on<ReserveFoodEvent>((event, emit) async {
      if(event is ReserveFood){
        await _handler(emit, event.params!);
      }
    });
  }

  Future<void> _handler(Emitter<ReserveFoodState> emit, Map<String, dynamic> params) async {
    emit(const ReserveFoodLoading());
    try{
      await _reserveFoodUseCase(params: params);
      emit(ReserveFoodDone());
    }catch(e){
      emit(ReserveFoodError());
    }
  }

}