import 'package:czestujem/domain/usecases/rate_user_usecase.dart';
import 'package:czestujem/presentation/blocs/rate_user_bloc/rate_user_event.dart';
import 'package:czestujem/presentation/blocs/rate_user_bloc/rate_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RateUserBloc extends Bloc<RateUserEvent, RateUserState> {
  final RateUserUseCase _rateUserUseCase;

  RateUserBloc(this._rateUserUseCase) : super(RateUserInitial()) {
    on<RateUserEvent>((event, emit) async {
      if (event is RateUser) {
        await _handler(emit, event.params!);
      }
    });
  }

  Future<void> _handler(Emitter<RateUserState> emit, Map<String, dynamic> params) async {
    emit(RateUserLoading());
    try{
      await _rateUserUseCase(params: params);
      emit(RateUserDone());
    }catch(e){
      print(e);
      emit(RateUserError());
    }
  }
}