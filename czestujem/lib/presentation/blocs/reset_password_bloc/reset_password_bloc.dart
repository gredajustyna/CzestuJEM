import 'package:czestujem/domain/usecases/reset_password_usecase.dart';
import 'package:czestujem/presentation/blocs/reset_password_bloc/reset_password_event.dart';
import 'package:czestujem/presentation/blocs/reset_password_bloc/reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState>{
  final ResetPasswordUseCase _resetPasswordUseCase;
  ResetPasswordBloc(this._resetPasswordUseCase) : super(ResetPasswordInitial()){
    on<ResetPasswordEvent>((event, emit) async {
      if(event is ResetPassword){
        await _handler(emit, event.email!);
      }
    });
  }

  Future<void> _handler(Emitter<ResetPasswordState> emit, String params) async {
    emit(const ResetPasswordLoading());
    var result = await _resetPasswordUseCase(params: params);
    if (result == 0) {
      emit(const ResetPasswordDone());
    } else if (result == 1) {
      emit(const ResetPasswordError());
    }
  }

}