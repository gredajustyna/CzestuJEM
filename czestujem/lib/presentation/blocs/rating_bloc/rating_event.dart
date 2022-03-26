abstract class RatingEvent{
  final String? uid;
  const RatingEvent({this.uid});
}

class GetUserRating extends RatingEvent{
  const GetUserRating(String uid) : super(uid: uid);
}