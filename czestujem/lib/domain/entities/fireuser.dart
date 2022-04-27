class FireUser{
  String uid;
  String photoURL;
  String name;
  double rating;
  int timesRated;
  double totalPoints;

  FireUser(this.uid, this.photoURL, this.rating, this.name, this.timesRated, this.totalPoints);

  FireUser.fromJSON(Map<String, dynamic> json):
      uid = json['uid'] as String,
      photoURL = (json['photoURL'] ?? '') as String,
      name =( json['name'] ?? '') as String,
      rating = (json['rating']).toDouble(),
      timesRated = json['timesRated'],
      totalPoints = (json['totalPoints']).toDouble();

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid' : uid,
    'photoURL' : photoURL,
    'name': name,
    'rating': rating,
    'timesRated' : timesRated,
    'totalPoints' : totalPoints,
  };

}