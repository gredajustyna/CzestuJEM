import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/usecases/get_all_messages_usecase.dart';
import 'package:czestujem/domain/usecases/send_message_usecase.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_event.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/message.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final GetAllMessagesUseCase _getAllMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  MessagesBloc(this._getAllMessagesUseCase, this._sendMessageUseCase) : super(MessagesInitial()) {
    on<MessagesEvent>((event, emit) async {
      if (event is GetAllMessages) {
        await _getAllMessagesHandler(emit, event.user!);
      }
      if(event is SendMessage){
        await _handler(emit, event.message!);
        await _getAllMessagesHandler(emit, event.message!['user']);
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
}

// class SendMessageBloc extends Bloc<MessagesEvent, SendMessageState>{
//   final SendMessageUseCase _sendMessageUseCase;
//
//   SendMessageBloc( this._sendMessageUseCase) : super(SendMessageInitial()) {
//     on<MessagesEvent>((event, emit) async {
//       if(event is SendMessage){
//         await _handler(emit, event.message!);
//       }
//     });
//   }
//
//   Future<void> _handler(Emitter<SendMessageState> emit, Map<String, dynamic> message) async {
//     emit(SendMessageLoading());
//
//     await _sendMessageUseCase(params: message);
//   }
// }