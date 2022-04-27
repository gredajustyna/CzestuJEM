import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetUsersToRateUseCase implements FutureUseCase<List<FireUser>, String>{
  AppRepository _appRepository;
  GetUsersToRateUseCase(this._appRepository);

  @override
  Future<List<FireUser>> call({required String params}) async{
    var result = await _appRepository.getUsersToRate(params);
    return result;
  }

}