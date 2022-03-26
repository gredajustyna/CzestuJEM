
import 'package:czestujem/domain/entities/food.dart';
import '../../core/usecases/future_usecase.dart';
import '../repositories/app_repository.dart';

class GetAllFavouritesUseCase implements FutureUseCase<List<Food>, String>{
  AppRepository _appRepository;
  GetAllFavouritesUseCase(this._appRepository);

  @override
  Future<List<Food>> call({required String params}) async{
    var result = await _appRepository.getAllFavourites(params);
    return result;

  }

}