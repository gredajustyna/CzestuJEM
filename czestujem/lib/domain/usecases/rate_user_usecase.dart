import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class RateUserUseCase implements FutureUseCase<void, Map<String, dynamic>>{
  AppRepository _appRepository;
  RateUserUseCase(this._appRepository);

  @override
  Future<void> call({required Map<String, dynamic> params}) async{
    await _appRepository.rateUser(params['user'], params['mark']);
  }

}