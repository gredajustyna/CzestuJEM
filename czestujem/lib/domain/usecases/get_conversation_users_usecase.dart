import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetConversationUsersUseCase implements FutureUseCase<List<FireUser>, void>{
  AppRepository _appRepository;
  GetConversationUsersUseCase(this._appRepository);

  @override
  Future<List<FireUser>> call({void params}) async{
    var result = await _appRepository.getConversationUsers();
    return result;
  }

}