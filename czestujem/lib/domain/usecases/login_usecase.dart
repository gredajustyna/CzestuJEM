import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class LoginUseCase implements FutureUseCase<dynamic, Map<String, String>>{
  AppRepository _appRepository;

  LoginUseCase(this._appRepository);

  @override
  Future call({required Map<String, String> params}) async{
    String? password = params['password'];
    String? email = params['email'];
    var result = await _appRepository.logIn(email!, password!);
    return result;
  }

}