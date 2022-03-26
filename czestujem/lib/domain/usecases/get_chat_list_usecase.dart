import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetChatListUseCase implements FutureUseCase<dynamic, String>{
  AppRepository _appRepository;
  GetChatListUseCase(this._appRepository);
  @override
  Future<dynamic> call({required String params}) async{
    var result = await _appRepository.getChatsList(params);
    return result;

  }

}