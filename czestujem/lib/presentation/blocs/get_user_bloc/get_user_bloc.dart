import 'package:czestujem/domain/usecases/get_user_from_uid%20_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_user_event.dart';
import 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState>{
  final GetUserFromUidUseCase _getUserFromUidUseCase;
  GetUserBloc(this._getUserFromUidUseCase) : super(GetUserInitial()){
    on<GetUserEvent>((event, emit) async {
      if(event is GetUser){
        await _handler(emit, event.uid!);
      }
    });
  }

  Future<void> _handler(Emitter<GetUserState> emit, String params) async {
    emit(const GetUserInitial());
    var result = await _getUserFromUidUseCase(params: params);
    try {
      emit(GetUserDone(result));
    } catch (e) {
      emit(GetUserError());
    }
  }
}