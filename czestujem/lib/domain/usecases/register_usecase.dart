import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class RegisterUseCase implements FutureUseCase<dynamic, Map<String, String>>{
  AppRepository _appRepository;
  RegisterUseCase(this._appRepository);


  @override
  Future call({required Map<String, String> params}) async{
    String? password = params['password'];
    String? email = params['email'];
    String? name = params['name'];
    var result = await _appRepository.register(email!, name!, password!);
    return result;
  }

}