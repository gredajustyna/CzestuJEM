import 'package:czestujem/domain/entities/fireuser.dart';

abstract class TopUsersState{
  final List<FireUser>? users;
  const TopUsersState({this.users});
}

class TopUsersInitial extends TopUsersState{
  const TopUsersInitial();
}

class TopUsersDone extends TopUsersState{
  const TopUsersDone(List<FireUser> users) : super (users: users);
}

class TopUsersLoading extends TopUsersState{
  const TopUsersLoading();
}

class TopUsersError extends TopUsersState{
  const TopUsersError();
}