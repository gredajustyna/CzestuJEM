import 'package:czestujem/domain/usecases/register_usecase.dart';
import 'package:czestujem/presentation/blocs/register_bloc/register_event.dart';
import 'package:czestujem/presentation/blocs/register_bloc/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  final RegisterUseCase _registerUseCase;
  RegisterBloc(this._registerUseCase) : super(const RegisterInitial()){
    on<RegisterEvent>((event, emit) async {
      if(event is Register){
        await _loginHandler(emit, event.params!);
      }
    });
  }

  Future<void> _loginHandler(Emitter<RegisterState> emit, Map<String, String> params) async {
    emit(const RegisterLoading());
    var result = await _registerUseCase(params: params);
    if(result == 22){
      emit(const RegisterErrorWeakPassword());
    }else if(result ==23){
      emit(const RegisterErrorUserExists());
    }else{
      emit(RegisterDone(result));
      print('register done');
    }
  }

}