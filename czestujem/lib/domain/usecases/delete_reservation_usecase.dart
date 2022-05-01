import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/reservation.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class DeleteReservationUseCase implements FutureUseCase<void, Reservation>{
  AppRepository _appRepository;
  DeleteReservationUseCase(this._appRepository);

  @override
  Future<void> call({required Reservation params}) async{
    await _appRepository.deleteReservation(params);
  }

}