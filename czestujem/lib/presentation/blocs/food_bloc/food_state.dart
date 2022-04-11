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

abstract class FoodByRadiusState{
  final List<Food>? foods;
  const FoodByRadiusState({this.foods});
}

class FoodByRadiusDone extends FoodByRadiusState{
  const FoodByRadiusDone(List<Food> foods): super(foods: foods);
}

class FoodByRadiusLoading extends FoodByRadiusState{
  const FoodByRadiusLoading();
}

class FoodByRadiusInitial extends FoodByRadiusState{
  const FoodByRadiusInitial();
}

class FoodByRadiusError extends FoodByRadiusState{
  const FoodByRadiusError();
}

