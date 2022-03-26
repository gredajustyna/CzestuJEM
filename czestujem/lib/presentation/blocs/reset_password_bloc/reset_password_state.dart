abstract class ResetPasswordState{
  const ResetPasswordState();
}

class ResetPasswordInitial extends ResetPasswordState{
  const ResetPasswordInitial();
}

class ResetPasswordLoading extends ResetPasswordState{
  const ResetPasswordLoading();
}

class ResetPasswordDone extends ResetPasswordState{
  const ResetPasswordDone();
}

class ResetPasswordError extends ResetPasswordState{
  const ResetPasswordError();
}

