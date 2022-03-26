import '../../../domain/entities/food.dart';

abstract class FoodState{
  const FoodState();
}

class FoodInitial extends FoodState{
  const FoodInitial();
}

class FoodLoading extends FoodState{
  const FoodLoading();
}

class FoodDone extends FoodState{
  const FoodDone();
}

class FoodError extends FoodState{
  const FoodError();
}

class FoodByRadiusState{
  final List<Food>? foods;
  const FoodByRadiusState({this.foods});
}