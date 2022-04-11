import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class SearchFoodUseCase implements FutureUseCase<List<Food>, String>{
  AppRepository _appRepository;
  SearchFoodUseCase(this._appRepository);

  @override
  Future<List<Food>> call({required String params}) async{
    var result = await _appRepository.searchFood(params);
    return result;
  }

}