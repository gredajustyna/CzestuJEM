import 'package:czestujem/domain/entities/message.dart';

abstract class MessagesState{
  final List<Message>? messages;
  const MessagesState({this.messages});
}

class MessagesInitial extends MessagesState{
  const MessagesInitial();
}

class MessagesLoading extends MessagesState{
  const MessagesLoading();
}

class MessagesDone extends MessagesState{
  const MessagesDone(List<Message> messages ): super(messages: messages);
}

class MessagesError extends MessagesState{
  const MessagesError();
}

abstract class SendMessageState{
  const SendMessageState();
}

class SendMessageInitial extends SendMessageState{
  const SendMessageInitial();
}

class SendMessageLoading extends SendMessageState{
  const SendMessageLoading();
}

class SendMessageDone extends SendMessageState{
  const SendMessageDone();
}

class SendMessageError extends SendMessageState{
  const SendMessageError();
}

abstract class GetLastMessageState{
  final Message? lastMessage;
  const GetLastMessageState({this.lastMessage});
}

class GetLastMessageInitial extends GetLastMessageState{
  const GetLastMessageInitial();
}

class GetLastMessageLoading extends GetLastMessageState{
  const GetLastMessageLoading();
}

class GetLastMessageDone extends GetLastMessageState{
  const GetLastMessageDone(Message message): super(lastMessage: message);
}

class GetLastMessageError extends GetLastMessageState{
  const GetLastMessageError();
}