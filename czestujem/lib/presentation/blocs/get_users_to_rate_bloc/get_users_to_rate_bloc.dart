import 'package:czestujem/domain/usecases/get_users_to_rate_usecase.dart';
import 'package:czestujem/presentation/blocs/get_users_to_rate_bloc/get_users_to_rate_event.dart';
import 'package:czestujem/presentation/blocs/get_users_to_rate_bloc/get_users_to_rate_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUsersToRateBloc extends Bloc<GetUsersToRateEvent, GetUsersToRateState> {
  final GetUsersToRateUseCase _getUsersToRateUseCase;

  GetUsersToRateBloc(this._getUsersToRateUseCase) : super(GetUsersToRateInitial()) {
    on<GetUsersToRateEvent>((event, emit) async {
      if (event is GetUsersToRate) {
        await _handler(emit, event.uid!);
      }
    });
  }

  Future<void> _handler(Emitter<GetUsersToRateState> emit, String uid) async {
    emit(GetUsersToRateLoading());
    try{
      var result = await _getUsersToRateUseCase(params: uid);
      emit(GetUsersToRateDone(result));
    }catch(e){
      emit(GetUsersToRateError());
    }
  }
}