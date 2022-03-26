import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetRatingUseCase implements FutureUseCase<dynamic, String>{
  AppRepository _appRepository;
  GetRatingUseCase(this._appRepository);

  @override
  Future call({required String params}) async{
    var result = await _appRepository.getUserRating(params);
    return result;
  }

}