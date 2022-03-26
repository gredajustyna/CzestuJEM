abstract class ResetPasswordEvent{
  final String? email;
  const ResetPasswordEvent({this.email});
}

class ResetPassword extends ResetPasswordEvent{
  const ResetPassword(String email) : super(email: email);
}