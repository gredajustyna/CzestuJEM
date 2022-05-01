abstract class ConfirmReservationState{
  const ConfirmReservationState();
}

class ConfirmReservationInitial extends ConfirmReservationState{
  const ConfirmReservationInitial();
}

class ConfirmReservationLoading extends ConfirmReservationState{
  const ConfirmReservationLoading();
}

class ConfirmReservationDone extends ConfirmReservationState{
  const ConfirmReservationDone();
}

class ConfirmReservationError extends ConfirmReservationState{
  const ConfirmReservationError();
}