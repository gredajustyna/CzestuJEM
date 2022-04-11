import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class UpdateUserDataUseCase implements FutureUseCase<void, Map<String, dynamic>>{
  AppRepository _appRepository;
  UpdateUserDataUseCase(this._appRepository);

  @override
  Future<void> call({required Map<String, dynamic> params}) async{
    await _appRepository.updateUserData(params);
  }

}