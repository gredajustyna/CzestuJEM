import 'package:czestujem/domain/entities/fireuser.dart';

abstract class GetUserState{
  final FireUser? user;
  const GetUserState({this.user});
}

class GetUserInitial extends GetUserState{
  const GetUserInitial();
}
class GetUserLoading extends GetUserState{
  const GetUserLoading();
}
class GetUserDone extends GetUserState{
  const GetUserDone(FireUser user): super (user: user);
}
class GetUserError extends GetUserState{
  const GetUserError();
}