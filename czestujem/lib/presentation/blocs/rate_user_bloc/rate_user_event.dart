abstract class RateUserEvent{
  final Map<String, dynamic>? params;
  const RateUserEvent({this.params});
}

class RateUser extends RateUserEvent{
  const RateUser(Map<String, dynamic> params):super(params: params);
}