import 'package:cloud_firestore/cloud_firestore.dart';

class Food{
  String photoURL;
  String name;
  String description;
  GeoPoint location;
  String category;
  DateTime expirationDate;
  String uid;
  String id;

  Food(this.photoURL, this.name, this.description, this.location, this.category, this.expirationDate, this.uid, this.id);

  Food.fromJSON(Map<String, dynamic> json) :
      photoURL = json['photoURL'] as String,
      name = json['name'] as String,
      description = json['description'] as String,
      location = GeoPoint(json['place'].latitude, json['place'].longitude),
      category = json['category'] as String,
      expirationDate = json['expirationDate'].toDate(),
      uid = json['uid'] as String,
      id = json['id'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'expirationDate': Timestamp.fromDate(expirationDate),
    'name': name,
    'description': description,
    'place' : location,
    'category' : category,
    'photoURL' : photoURL,
    'uid' : uid,
    'id' : id
  };

}