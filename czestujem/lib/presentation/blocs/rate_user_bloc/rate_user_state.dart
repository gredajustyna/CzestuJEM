abstract class RateUserState{
  const RateUserState();
}

class RateUserInitial extends RateUserState{
  const RateUserInitial();
}

class RateUserLoading extends RateUserState{
  const RateUserLoading();
}

class RateUserDone extends RateUserState{
  const RateUserDone();
}

class RateUserError extends RateUserState{
  const RateUserError();
}