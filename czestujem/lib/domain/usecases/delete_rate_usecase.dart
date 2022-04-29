import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class DeleteRateUseCase implements FutureUseCase<void, FireUser>{
  AppRepository _appRepository;
  DeleteRateUseCase(this._appRepository);

  @override
  Future<void> call({required FireUser params}) async{
    await _appRepository.deleteRate(params);
  }

}