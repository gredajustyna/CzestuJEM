abstract class DeleteFoodState{
  const DeleteFoodState();
}

class DeleteFoodInitial extends DeleteFoodState{
  const DeleteFoodInitial();
}

class DeleteFoodLoading extends DeleteFoodState{
  const DeleteFoodLoading();
}

class DeleteFoodDone extends DeleteFoodState{
  const DeleteFoodDone();
}

class DeleteFoodError extends DeleteFoodState{
  const DeleteFoodError();
}