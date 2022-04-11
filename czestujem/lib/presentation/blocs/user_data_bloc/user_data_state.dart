abstract class UserDataState{
  const UserDataState();
}

class UserDataInitial extends UserDataState{
  const UserDataInitial();
}

class UserDataLoading extends UserDataState{
  const UserDataLoading();
}

class UserDataDone extends UserDataState{
  const UserDataDone();
}

class UserDataError extends UserDataState{
  const UserDataError();
}