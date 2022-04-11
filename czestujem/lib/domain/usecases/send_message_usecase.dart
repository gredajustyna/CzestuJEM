import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class SendMessageUseCase implements FutureUseCase<void, Map<String, dynamic>>{
  final AppRepository _appRepository;
  SendMessageUseCase(this._appRepository);

  @override
  Future<void> call({required Map<String, dynamic> params}) async{
    await _appRepository.sendMessage(params['user'], params['message']);
  }

}