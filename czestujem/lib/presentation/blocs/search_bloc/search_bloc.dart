import 'package:czestujem/domain/usecases/search_food_usecase.dart';
import 'package:czestujem/presentation/blocs/search_bloc/search_event.dart';
import 'package:czestujem/presentation/blocs/search_bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchFoodUseCase _searchFoodUseCase;

  SearchBloc(this._searchFoodUseCase) : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      if (event is SearchFood) {
        await _handler(emit, event.name!);
      }
    });
  }

  Future<void> _handler(Emitter<SearchState> emit, String name) async {
    emit(SearchLoading());
    var result = await _searchFoodUseCase(params: name);
    if(result != null){
      emit(SearchDone(result));
    }else{
      emit(SearchError());
    }
  }
}