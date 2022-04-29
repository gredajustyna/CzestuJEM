import 'package:czestujem/domain/entities/food.dart';

abstract class DeleteFoodEvent{
  final Food? food;
  const DeleteFoodEvent({this.food});
}

class DeleteFood extends DeleteFoodEvent{
  const DeleteFood(Food food): super(food: food);
}