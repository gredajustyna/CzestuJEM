abstract class FoodEvent{
  final Map<String, dynamic>? foodToAdd;
  const FoodEvent({this.foodToAdd});
}

class AddFood extends FoodEvent{
  const AddFood(Map<String, dynamic> foodToAdd): super(foodToAdd: foodToAdd);
}

class GetFoodByRadius extends FoodEvent{
  const GetFoodByRadius();
}