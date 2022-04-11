import 'package:czestujem/core/usecases/future_usecase.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

class GetDocumentIdUseCase implements FutureUseCase<String, FireUser>{
  AppRepository _appRepository;
  GetDocumentIdUseCase(this._appRepository);

  @override
  Future<String> call({required FireUser params}) async{
    var result = await _appRepository.getConversationDocId(params);
    return result;
  }

}