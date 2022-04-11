import 'package:czestujem/domain/entities/food.dart';

abstract class SearchState{
  final List<Food>? foods;
  const SearchState({this.foods});
}

class SearchInitial extends SearchState{
  const SearchInitial();
}

class SearchLoading extends SearchState{
  const SearchLoading();
}

class SearchDone extends SearchState{
  const SearchDone(List<Food> foods) : super(foods: foods);
}

class SearchError extends SearchState{
  const SearchError();
}