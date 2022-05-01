import 'package:czestujem/domain/entities/reservation.dart';

abstract class DeleteReservationEvent{
  final Reservation? reservation;
  const DeleteReservationEvent({this.reservation});
}

class DeleteReservation extends DeleteReservationEvent{
  const DeleteReservation(Reservation reservation) : super(reservation: reservation);
}