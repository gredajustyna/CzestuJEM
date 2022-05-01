import 'package:czestujem/domain/entities/reservation.dart';

abstract class ConfirmReservationEvent{
  final Reservation? reservation;
  const ConfirmReservationEvent({this.reservation});
}

class ConfirmReservation extends ConfirmReservationEvent{
  const ConfirmReservation(Reservation reservation):super(reservation: reservation);
}