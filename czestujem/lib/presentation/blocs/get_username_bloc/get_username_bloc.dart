import 'package:czestujem/domain/usecases/get_username_from_uid_usecase.dart';
import 'package:czestujem/domain/usecases/login_usecase.dart';
import 'package:czestujem/presentation/blocs/get_username_bloc/get_username_event.dart';
import 'package:czestujem/presentation/blocs/get_username_bloc/get_username_state.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUsernameBloc extends Bloc<GetUsernameEvent, GetUsernameState>{
  final GetUsernameFromUidUseCase _getUsernameFromUidUseCase;
  GetUsernameBloc(this._getUsernameFromUidUseCase) : super(GetUsernameInitial()){
    on<GetUsernameEvent>((event, emit) async {
      if(event is GetUsername){
        await _loginHandler(emit, event.uid!);
      }
    });
  }

  Future<void> _loginHandler(Emitter<GetUsernameState> emit, String params) async {
    emit(const GetUsernameInitial());
    var result = await _getUsernameFromUidUseCase(params: params);
    if(result != null){
      emit(GetUsernameDone(result));
    }else {
      emit(GetUsernameError());
    }
  }

}