import 'package:czestujem/domain/usecases/login_usecase.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_event.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<GetUsernameEvent, LoginState>{
  final LoginUseCase _loginUseCase;
  LoginBloc(this._loginUseCase) : super(LoginInitial()){
    on<GetUsernameEvent>((event, emit) async {
      if(event is LogIn){
        await _loginHandler(emit, event.params!);
      }
    });
  }

  Future<void> _loginHandler(Emitter<LoginState> emit, Map<String, String> params) async {
    emit(const LoginLoading());
    var result = await _loginUseCase(params: params);
    if(result == 24){
      emit(const LoginErrorUserNotFound());
    }else if(result ==25){
      emit(const LoginErrorWrongPassword());
    }else if (result.runtimeType == User){
      emit(LoginDone(result));
      print('done');
    }else if(result == 26){
      emit(const LoginErrorTooManyRequests());
    }
    else{
      print('else');
    }
  }

}