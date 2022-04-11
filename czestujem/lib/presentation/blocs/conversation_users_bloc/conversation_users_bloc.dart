import 'package:czestujem/domain/usecases/get_conversation_users_usecase.dart';
import 'package:czestujem/presentation/blocs/conversation_users_bloc/conversation_users_event.dart';
import 'package:czestujem/presentation/blocs/conversation_users_bloc/conversation_users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationUsersBloc extends Bloc<ConversationUsersEvent, ConversationUsersState> {
  final GetConversationUsersUseCase _getConversationUsersUseCase;

  ConversationUsersBloc(this._getConversationUsersUseCase) : super(ConversationUsersInitial()) {
    on<ConversationUsersEvent>((event, emit) async {
      if (event is GetConversationUsers) {
        await _handler(emit);
      }
    });
  }

  Future<void> _handler(Emitter<ConversationUsersState> emit) async {
    emit(ConversationUsersLoading());
    try{
      var result = await _getConversationUsersUseCase();
      print(result);
      emit(ConversationUsersDone(result));
    }catch(e){
      emit(ConversationUsersError());
    }
  }
}