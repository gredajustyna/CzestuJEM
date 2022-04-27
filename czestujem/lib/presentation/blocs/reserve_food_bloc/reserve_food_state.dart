abstract class ReserveFoodState{
  const ReserveFoodState();
}

class ReserveFoodInitial extends ReserveFoodState{
  const ReserveFoodInitial();
}

class ReserveFoodLoading extends ReserveFoodState{
  const ReserveFoodLoading();
}

class ReserveFoodDone extends ReserveFoodState{
  const ReserveFoodDone();
}

class ReserveFoodError extends ReserveFoodState{
  const ReserveFoodError();
}