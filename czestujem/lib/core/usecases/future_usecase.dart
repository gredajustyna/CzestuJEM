abstract class FutureUseCase <T, P>{
  Future<T> call({required P params});
}