import 'package:czestujem/domain/usecases/delete_reservation_usecase.dart';
import 'package:czestujem/presentation/blocs/confirm_reservstion_bloc/confirm_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/reservation.dart';
import 'delete_reservation_event.dart';
import 'delete_reservation_state.dart';

class DeleteReservationBloc extends Bloc<DeleteReservationEvent, DeleteReservationState>{
  final DeleteReservationUseCase _deleteReservationUseCase;
  DeleteReservationBloc(this._deleteReservationUseCase) : super(DeleteReservationInitial()){
    on<DeleteReservationEvent>((event, emit) async {
      if(event is DeleteReservation){
        await _handler(emit, event.reservation!);
      }
    });
  }

  Future<void> _handler(Emitter<DeleteReservationState> emit, Reservation params) async {
    emit(const DeleteReservationLoading());
    try{
      await _deleteReservationUseCase(params: params);
      emit(DeleteReservationDone());
    }catch(e){
      emit(DeleteReservationError());
    }
  }

}