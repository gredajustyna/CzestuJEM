import 'package:czestujem/domain/entities/fireuser.dart';

abstract class GetUsersToRateState{
  final List<FireUser>? users;
  const GetUsersToRateState({this.users});
}

class GetUsersToRateInitial extends GetUsersToRateState{
  const GetUsersToRateInitial();
}

class GetUsersToRateLoading extends GetUsersToRateState{
  const GetUsersToRateLoading();
}

class GetUsersToRateDone extends GetUsersToRateState{
  const GetUsersToRateDone(List<FireUser> users):super(users: users);
}

class GetUsersToRateError extends GetUsersToRateState{
  const GetUsersToRateError();
}