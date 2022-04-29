import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/usecases/get_all_messages_usecase.dart';
import 'package:czestujem/domain/usecases/get_last_message_usecase.dart';
import 'package:czestujem/domain/usecases/read_messages_usecase.dart';
import 'package:czestujem/domain/usecases/send_message_usecase.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_event.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/message.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final GetAllMessagesUseCase _getAllMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final ReadMessagesUseCase _readMessagesUseCase;

  MessagesBloc(this._getAllMessagesUseCase, this._sendMessageUseCase, this._readMessagesUseCase) : super(MessagesInitial()) {
    on<MessagesEvent>((event, emit) async {
      if (event is GetAllMessages) {
        await _getAllMessagesHandler(emit, event.user!);
      }
      if(event is SendMessage){
        await _handler(emit, event.message!);
        await _getAllMessagesHandler(emit, event.message!['user']);
      }
      if(event is ReadMessages){
        await _readHandler(emit, event.user!);
        await _getAllMessagesHandler(emit, event.user!);
      }
    });
  }

  Future<void> _getAllMessagesHandler(Emitter<MessagesState> emit, FireUser user) async {
    emit(MessagesLoading());
    try{
      var result = await _getAllMessagesUseCase(params: user);
      emit(MessagesDone(result));
    }catch(e){
      emit(MessagesError());
    }
  }

  Future<void> _handler(Emitter<MessagesState> emit, Map<String, dynamic> message) async {
    await _sendMessageUseCase(params: message);
  }

  Future<void> _readHandler(Emitter<MessagesState> emit, FireUser params) async {
    await _readMessagesUseCase(params: params);
  }
}

class GetLastMessageBloc extends Bloc<MessagesEvent, GetLastMessageState>{
  final GetLastMessageUseCase _getLastMessageUseCase;

  GetLastMessageBloc( this._getLastMessageUseCase) : super(GetLastMessageInitial()) {
    on<MessagesEvent>((event, emit) async {
      if(event is GetLastMessage){
        await _handler(emit, event.user!);
      }
    });
  }

  Future<void> _handler(Emitter<GetLastMessageState> emit, FireUser user) async {
    emit(GetLastMessageLoading());
    try{
      var result = await _getLastMessageUseCase(params: user);
      emit(GetLastMessageDone(result));
    }catch(e){
     emit(GetLastMessageError());
    }
  }
}