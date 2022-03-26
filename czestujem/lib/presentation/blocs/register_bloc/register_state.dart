import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterState{
  final User? user;
  const RegisterState({this.user});
}

class RegisterInitial extends RegisterState{
  const RegisterInitial();
}

class RegisterLoading extends RegisterState{
  const RegisterLoading();
}

class RegisterDone extends RegisterState{
  const RegisterDone(User user) : super(user: user);
}

class RegisterErrorWeakPassword extends RegisterState{
  const RegisterErrorWeakPassword();
}

class RegisterErrorUserExists extends RegisterState{
  const RegisterErrorUserExists();
}