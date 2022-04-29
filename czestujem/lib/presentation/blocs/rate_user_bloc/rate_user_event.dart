import '../../../domain/entities/fireuser.dart';

abstract class RateUserEvent{
  final Map<String, dynamic>? params;
  final FireUser? user;
  const RateUserEvent({this.params, this.user});
}

class RateUser extends RateUserEvent{
  const RateUser(Map<String, dynamic> params):super(params: params);
}

class DeleteRate extends RateUserEvent{
  const DeleteRate(FireUser user):super(user: user);
}