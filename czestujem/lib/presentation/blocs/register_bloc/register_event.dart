abstract class RegisterEvent{
  final Map<String, String>? params;
  const RegisterEvent({this.params});
}

class Register extends RegisterEvent{
  const Register(Map<String, String> params) : super(params: params);
}