abstract class GetUsersToRateEvent{
  final String? uid;
  GetUsersToRateEvent({this.uid});
}

class GetUsersToRate extends GetUsersToRateEvent{
  GetUsersToRate(String uid): super(uid: uid);
}