import 'package:czestujem/core/usecases/future_usecase.dart';

import '../repositories/app_repository.dart';

class GetUsernameFromUidUseCase implements FutureUseCase<String, String>{
  AppRepository _appRepository;
  GetUsernameFromUidUseCase(this._appRepository);

  @override
  Future<String> call({required String params}) async {
    var result = await _appRepository.getUsernameFromUid(params);
    return result;
  }

}