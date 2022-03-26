abstract class GetUsernameEvent{
  final Map<String, String>? params;
  const GetUsernameEvent({this.params});
}

class LogIn extends GetUsernameEvent{
  const LogIn(Map<String, String>? params) : super(params: params);
}