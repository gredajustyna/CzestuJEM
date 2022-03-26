import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class AddFoodUseCase implements FutureUseCase<dynamic, Map<String, dynamic>>{
  AppRepository _appRepository;
  AddFoodUseCase(this._appRepository);

  @override
  Future call({required Map<String, dynamic> params}) async{
    var result = await _appRepository.addFood(params['foodFileName'], params['foodImageFile'], params['food']);
    return result;
  }

}