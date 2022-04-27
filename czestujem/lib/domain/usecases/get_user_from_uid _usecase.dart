import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetUserFromUidUseCase implements FutureUseCase <FireUser, String>{
  AppRepository _appRepository;
  GetUserFromUidUseCase(this._appRepository);

  @override
  Future<FireUser> call({required String params}) async{
    var result = await _appRepository.getUserFromUid(params);
    return result;
  }

}