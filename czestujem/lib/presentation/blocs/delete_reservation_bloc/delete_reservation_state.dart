abstract class DeleteReservationState{
  const DeleteReservationState();
}

class DeleteReservationInitial extends DeleteReservationState{
  const DeleteReservationInitial();
}

class DeleteReservationLoading extends DeleteReservationState{
  const DeleteReservationLoading();
}

class DeleteReservationDone extends DeleteReservationState{
  const DeleteReservationDone();
}

class DeleteReservationError extends DeleteReservationState{
  const DeleteReservationError();
}