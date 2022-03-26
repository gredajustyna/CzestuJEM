abstract class FridgeEvent{
  final String? uid;
  const FridgeEvent({this.uid});
}

class GetMyFridge extends FridgeEvent{
  GetMyFridge(String uid) : super (uid: uid);
}