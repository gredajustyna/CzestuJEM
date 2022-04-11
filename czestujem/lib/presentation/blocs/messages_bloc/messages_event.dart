import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/entities/message.dart';

abstract class MessagesEvent{
  final FireUser? user;
  final Map<String, dynamic>? message;
  const MessagesEvent({this.user, this.message});
}

class GetAllMessages extends MessagesEvent{
  const GetAllMessages(FireUser user) :super(user: user);
}

class SendMessage extends MessagesEvent{
  const SendMessage(Map<String, dynamic>? message) : super(message: message);
}