import 'package:czestujem/domain/entities/food.dart';

abstract class FridgeState{
  final List<Food>? fridge;
  const FridgeState({this.fridge});
}

class FridgeInitial extends FridgeState{
  const FridgeInitial();
}

class FridgeLoading extends FridgeState{
  const FridgeLoading();
}

class FridgeDone extends FridgeState{
  const FridgeDone(List<Food> fridge) : super(fridge: fridge);
}

class FridgeError extends FridgeState{
  const FridgeError();
}