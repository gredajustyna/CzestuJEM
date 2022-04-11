import 'package:czestujem/domain/usecases/update_user_data_usecase.dart';
import 'package:czestujem/presentation/blocs/user_data_bloc/user_data_event.dart';
import 'package:czestujem/presentation/blocs/user_data_bloc/user_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final UpdateUserDataUseCase _updateUserDataUseCase;

  UserDataBloc(this._updateUserDataUseCase) : super(UserDataInitial()) {
    on<UserDataEvent>((event, emit) async {
      if (event is UpdateUserData) {
        await _handler(emit, event.data!);
      }
    });
  }

  Future<void> _handler(Emitter<UserDataState> emit, Map<String, dynamic> params) async {
    emit(UserDataLoading());
    try{
      await _updateUserDataUseCase(params: params);
      emit(UserDataDone());
    }catch(e){
      emit(UserDataError());
    }
  }
}