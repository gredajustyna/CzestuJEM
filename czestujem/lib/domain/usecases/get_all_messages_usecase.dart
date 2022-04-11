import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/entities/message.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetAllMessagesUseCase implements FutureUseCase<List<Message>, FireUser>{
  AppRepository _appRepository;
  GetAllMessagesUseCase(this._appRepository);

  @override
  Future<List<Message>> call({required FireUser params}) async{
    var result = await _appRepository.getAllMessages(params);
    return result;
  }

}