abstract class GetUsernameEvent{
  final String? uid;
  const GetUsernameEvent({this.uid});
}

class GetUsername extends GetUsernameEvent{
  const GetUsername(String uid) :super(uid: uid);
}