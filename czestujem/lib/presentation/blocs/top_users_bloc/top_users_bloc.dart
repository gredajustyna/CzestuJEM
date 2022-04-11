import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/usecases/get_top_users_usecase.dart';
import 'package:czestujem/presentation/blocs/top_users_bloc/top_users_event.dart';
import 'package:czestujem/presentation/blocs/top_users_bloc/top_users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopUsersBloc extends Bloc<TopUsersEvent, TopUsersState> {
  final GetTopUsersUseCase _getTopUsersUseCase;

  TopUsersBloc(this._getTopUsersUseCase) : super(TopUsersInitial()) {
    on<TopUsersEvent>((event, emit) async {
      if (event is GetTopUsers) {
        await _handler(emit);
      }
    });
  }

  Future<void> _handler(Emitter<TopUsersState> emit) async {
    emit(TopUsersLoading());
    try{
      var result = await _getTopUsersUseCase();
      emit(TopUsersDone(result));
    }catch(e){
      emit(TopUsersError());
    }
  }
}