import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetFoodByRadiusUseCase implements FutureUseCase<List<Food>, void>{
  AppRepository _appRepository;
  GetFoodByRadiusUseCase(this._appRepository);

  @override
  Future<List<Food>> call({void params}) async{
    var result = await _appRepository.getFoodByRadius();
    print('result is $result');
    return result;
  }

}