abstract class GetUsernameState{
  final String? username;
  const GetUsernameState({this.username});
}

class GetUsernameLoading extends GetUsernameState{
  const GetUsernameLoading();
}

class GetUsernameInitial extends GetUsernameState{
  const GetUsernameInitial();
}

class GetUsernameDone extends GetUsernameState{
  const GetUsernameDone(String username) : super(username: username);
}

class GetUsernameError extends GetUsernameState{
  const GetUsernameError();
}