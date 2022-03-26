import 'package:czestujem/core/usecases/future_usecase.dart';

import '../repositories/app_repository.dart';

class ResetPasswordUseCase implements FutureUseCase<int, String>{
  AppRepository _appRepository;
  ResetPasswordUseCase(this._appRepository);

  @override
  Future<int> call({required String params}) async{
    int result = await _appRepository.resetPassword(params);
    return result;
  }

}