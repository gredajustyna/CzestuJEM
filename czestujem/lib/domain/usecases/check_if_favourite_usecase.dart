import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class CheckIfFavouriteUseCase implements FutureUseCase<bool?, Food>{
  AppRepository _appRepository;
  CheckIfFavouriteUseCase(this._appRepository);

  @override
  Future<bool?> call({required Food params}) async{
    var result = await _appRepository.checkIfFavourite(params);
    return result;
  }

}