abstract class ReserveFoodEvent{
  final Map<String, dynamic>? params;
  const ReserveFoodEvent({this.params});
}

class ReserveFood extends ReserveFoodEvent{
  const ReserveFood(Map<String, dynamic> params):super(params: params);
}