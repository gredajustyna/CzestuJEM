abstract class RatingState{
  final rating;
  const RatingState({this.rating});
}

class RatingInitial extends RatingState{
  const RatingInitial();
}

class RatingLoading extends RatingState{
  const RatingLoading();
}

class RatingDone extends RatingState{
  const RatingDone(var rating) : super(rating: rating);
}

class RatingError extends RatingState{
  const RatingError();
}