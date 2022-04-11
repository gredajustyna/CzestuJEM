import 'package:czestujem/domain/entities/fireuser.dart';

abstract class ConversationUsersState{
  final List<FireUser>? users;
  const ConversationUsersState({this.users});
}

class ConversationUsersInitial extends ConversationUsersState{
  const ConversationUsersInitial();
}

class ConversationUsersLoading extends ConversationUsersState{
  const ConversationUsersLoading();
}

class ConversationUsersDone extends ConversationUsersState{
  const ConversationUsersDone(List<FireUser> users):super(users: users);
}

class ConversationUsersError extends ConversationUsersState{
  const ConversationUsersError();
}
