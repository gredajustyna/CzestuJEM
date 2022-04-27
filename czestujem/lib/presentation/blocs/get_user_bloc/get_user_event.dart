abstract class GetUserEvent{
  final String? uid;
  const GetUserEvent({this.uid});
}

class GetUser extends GetUserEvent{
  const GetUser(String uid) : super(uid: uid);
}