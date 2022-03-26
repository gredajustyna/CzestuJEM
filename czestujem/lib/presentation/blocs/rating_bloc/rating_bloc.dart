import 'package:czestujem/domain/usecases/get_rating_usecase.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_event.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState>{
  final GetRatingUseCase _getRatingUseCase;
  RatingBloc(this._getRatingUseCase) : super(RatingInitial()){
    on<RatingEvent>((event, emit) async {
      if(event is GetUserRating){
        await _handler(emit, event.uid!);
      }
    });
  }

  Future<void> _handler(Emitter<RatingState> emit, String params) async {
    emit(RatingLoading());
    var result = await _getRatingUseCase(params: params);
    if(result != null){
      emit(RatingDone(result));
    }else{
      emit(RatingError());
    }
  }
}