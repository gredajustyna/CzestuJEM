import '../../../domain/entities/food.dart';

abstract class CheckFavouritesState{
  final bool? isFavourite;
  const CheckFavouritesState({this.isFavourite});
}
class CheckFavouritesDone extends CheckFavouritesState{
  const CheckFavouritesDone(bool? isFavourite) : super(isFavourite: isFavourite);
}

class CheckFavouritesInitial extends CheckFavouritesState{
  const CheckFavouritesInitial();
}

class CheckFavouritesLoading extends CheckFavouritesState{
  const CheckFavouritesLoading();
}

class CheckFavouritesError extends CheckFavouritesState{
  const CheckFavouritesError();
}

abstract class AddRemoveFavouritesState{
  const AddRemoveFavouritesState();
}

class AddRemoveFavouritesInitial extends AddRemoveFavouritesState{
  const AddRemoveFavouritesInitial();
}

class AddRemoveFavouritesLoading extends AddRemoveFavouritesState{
  const AddRemoveFavouritesLoading();
}

class AddRemoveFavouritesDone extends AddRemoveFavouritesState{
  const AddRemoveFavouritesDone();
}

class AddRemoveFavouritesError extends AddRemoveFavouritesState{
  const AddRemoveFavouritesError();
}

abstract class GetFavouritesState{
  final List<Food>? foods;
  GetFavouritesState({this.foods});
}

class GetFavouritesInitial extends GetFavouritesState{
  GetFavouritesInitial();
}

class GetFavouritesLoading extends GetFavouritesState{
  GetFavouritesLoading();
}

class GetFavouritesDone extends GetFavouritesState{
  GetFavouritesDone(List<Food> foods) : super(foods: foods);
}

class GetFavouritesError extends GetFavouritesState{
  GetFavouritesError();
}
