import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState{
  final User? user;
  const LoginState({this.user});
}

class LoginInitial extends LoginState{
  const LoginInitial();
}

class LoginLoading extends LoginState{
  const LoginLoading();
}

class LoginDone extends LoginState{
  const LoginDone(User user) : super(user: user);
}

class LoginErrorUserNotFound extends LoginState{
  const LoginErrorUserNotFound();
}

class LoginErrorWrongPassword extends LoginState{
  const LoginErrorWrongPassword();
}

class LoginErrorTooManyRequests extends LoginState{
  const LoginErrorTooManyRequests();
}