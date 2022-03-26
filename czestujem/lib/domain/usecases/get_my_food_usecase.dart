import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

import '../entities/food.dart';

class GetMyFoodUseCase implements FutureUseCase<List<Food>, String>{
  AppRepository _appRepository;
  GetMyFoodUseCase(this._appRepository);

  @override
  Future<List<Food>> call({required String params}) async{
    var result = await _appRepository.getMyFood(params);
    return result;
  }

}