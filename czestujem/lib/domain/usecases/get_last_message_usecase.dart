import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/entities/message.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetLastMessageUseCase implements FutureUseCase<Message, FireUser>{
  AppRepository _appRepository;
  GetLastMessageUseCase(this._appRepository);

  @override
  Future<Message> call({required FireUser params}) async{
    var result = await _appRepository.getLastMessage(params);
    return result;
  }

}