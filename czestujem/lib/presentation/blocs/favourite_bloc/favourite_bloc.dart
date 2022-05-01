
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/usecases/add_to_favourites_usecase.dart';
import 'package:czestujem/domain/usecases/check_if_favourite_usecase.dart';
import 'package:czestujem/domain/usecases/get_all_favourites_usecase.dart';
import 'package:czestujem/domain/usecases/remove_from_favourites_usecase.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_event.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckFavouriteBloc extends Bloc<FavouriteEvent, CheckFavouritesState>{
  final CheckIfFavouriteUseCase _checkIfFavouriteUseCase;
  CheckFavouriteBloc(this._checkIfFavouriteUseCase) : super(CheckFavouritesInitial()){
    on<FavouriteEvent>((event, emit) async {
      if(event is CheckIfFavourite){
        await _favouriteHandler(emit, event.food!);
      }
    });
  }

  Future<void> _favouriteHandler(Emitter<CheckFavouritesState> emit, Food params) async {
    emit(const CheckFavouritesLoading());
    var result = await _checkIfFavouriteUseCase(params: params);
    print('check fave result is $result');
    if(result == true){
      emit(CheckFavouritesDone(true));
    }else if(result ==false){
      emit(CheckFavouritesDone(false));
    }else{
      emit(CheckFavouritesError());
    }
  }
}

class FavouriteBloc extends Bloc<FavouriteEvent, AddRemoveFavouritesState>{
  final AddToFavouritesUseCase _addToFavouritesUseCase;
  final RemoveFromFavouritesUseCase _removeFromFavouritesUseCase;
  FavouriteBloc(this._removeFromFavouritesUseCase, this._addToFavouritesUseCase) : super(AddRemoveFavouritesInitial()){
    on<FavouriteEvent>((event, emit) async {
      if(event is AddToFavourites){
        await _addToFavouriteHandler(emit, event.food!);
      }
      if(event is RemoveFromFavourites){
        await _removeFromFavouriteHandler(emit, event.food!);
      }
    });
  }

  Future<void> _addToFavouriteHandler(Emitter<AddRemoveFavouritesState> emit, Food params) async {
    emit(const AddRemoveFavouritesLoading());
    var result = await _addToFavouritesUseCase(params: params);
    emit(AddRemoveFavouritesDone());
  }

  Future<void> _removeFromFavouriteHandler(Emitter<AddRemoveFavouritesState> emit, Food params) async {
    emit(const AddRemoveFavouritesLoading());
    var result = await _removeFromFavouritesUseCase(params: params);
    emit(AddRemoveFavouritesDone());
  }

}

class GetFavouritesBloc extends Bloc<FavouriteEvent, GetFavouritesState>{
  final GetAllFavouritesUseCase _getAllFavouritesUseCase;
  GetFavouritesBloc(this._getAllFavouritesUseCase) : super(GetFavouritesInitial()){
    on<FavouriteEvent>((event, emit) async {
      if(event is GetAllFavourites){
        await _favouriteHandler(emit, event.uid!);
      }
    });
  }

  Future<void> _favouriteHandler(Emitter<GetFavouritesState> emit, String params) async {
    emit(GetFavouritesLoading());
    var result = await _getAllFavouritesUseCase(params: params);
    if(result != null){
      emit(GetFavouritesDone(result));
    }else{
      emit(GetFavouritesError());
    }
  }
}