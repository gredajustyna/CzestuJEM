import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class DeleteFoodUseCase implements FutureUseCase<void, Food>{
  AppRepository _appRepository;
  DeleteFoodUseCase(this._appRepository);

  @override
  Future<void> call({required Food params}) async{
    await _appRepository.deleteFood(params);
  }

}