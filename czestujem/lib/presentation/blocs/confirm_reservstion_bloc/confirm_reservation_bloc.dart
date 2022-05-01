import 'package:czestujem/domain/entities/reservation.dart';
import 'package:czestujem/domain/usecases/confirm_reservation_usecase.dart';
import 'package:czestujem/presentation/blocs/confirm_reservstion_bloc/confirm_reservation_event.dart';
import 'package:czestujem/presentation/blocs/confirm_reservstion_bloc/confirm_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmReservationBloc extends Bloc<ConfirmReservationEvent, ConfirmReservationState>{
  final ConfirmReservationUseCase _confirmReservationUseCase;
  ConfirmReservationBloc(this._confirmReservationUseCase) : super(ConfirmReservationInitial()){
    on<ConfirmReservationEvent>((event, emit) async {
      if(event is ConfirmReservation){
        await _handler(emit, event.reservation!);
      }
    });
  }

  Future<void> _handler(Emitter<ConfirmReservationState> emit, Reservation params) async {
    emit(const ConfirmReservationLoading());
    try{
      await _confirmReservationUseCase(params: params);
      emit(ConfirmReservationDone());
    }catch(e){
      emit(ConfirmReservationError());
    }
  }

}