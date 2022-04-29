import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class ReadMessagesUseCase implements FutureUseCase<void, FireUser>{
  AppRepository _appRepository;
  ReadMessagesUseCase(this._appRepository);

  @override
  Future<void> call({required FireUser params}) async{
    await _appRepository.readMessages(params);
  }

}