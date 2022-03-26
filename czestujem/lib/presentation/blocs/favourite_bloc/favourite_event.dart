import '../../../domain/entities/food.dart';

abstract class FavouriteEvent{
  final Food? food;
  final String?  uid;
  const FavouriteEvent({this.food, this.uid});
}

class CheckIfFavourite extends FavouriteEvent{
  const CheckIfFavourite(Food food) : super(food: food);
}

class AddToFavourites extends FavouriteEvent{
  const AddToFavourites(Food food) : super(food: food);
}

class RemoveFromFavourites extends FavouriteEvent{
  const RemoveFromFavourites(Food food) : super(food: food);
}

class GetAllFavourites extends FavouriteEvent{
  const GetAllFavourites(String uid) : super(uid: uid);
}