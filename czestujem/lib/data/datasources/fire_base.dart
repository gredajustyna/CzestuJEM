import 'dart:io';
import 'dart:math';
import 'package:czestujem/core/utils/globals.dart' as globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';

class FireBase{
  static Future<dynamic> getChatsList({required String uid}){
    var result;
    CollectionReference chats = FirebaseFirestore.instance.collection("chats");
    chats.where('users', arrayContains: uid ).get().then((QuerySnapshot querySnapshot) => {
      if(querySnapshot.docs.isNotEmpty){
        result = querySnapshot.docs,
        print('result')
      }else{
        result = 0
      }
    });
    return result;
  }

  static Future<void> createChat(chatUsers)async {
    FirebaseFirestore.instance.collection('chats').doc().set(chatUsers).catchError((e){});
  }

  static Future<String> getUserName(String uid) async{
    CollectionReference users = FirebaseFirestore.instance.collection("usersCollection");
    var x = users.doc(uid).get();
    print(x);
    return x.toString();
  }

  static Future<String> getUsernameFromUid(String uid) async{
    String username ='';
    await FirebaseFirestore.instance.collection('usersCollection').where('uid', isEqualTo: uid).get().then((QuerySnapshot querySnapshot) => {
      if(querySnapshot.docs.isNotEmpty){
        username = querySnapshot.docs.first['name'],
      }else{
        username = '',
      }
    });
    return username;
  }
  
  static Future<dynamic> addFood(String foodFileName, File foodImageFile, Food food) async{
    if(food.photoURL =='1'){
      var uploadTask = await FirebaseStorage.instance.ref(foodFileName).putFile(foodImageFile).whenComplete(() async =>
      food.photoURL = await FirebaseStorage.instance.ref(foodFileName).getDownloadURL(),
      );
    }
    await FirebaseFirestore.instance.collection('foodCollection').add(food.toJson()).catchError((e){return 1;});
  }

  static Future<bool?> checkIfFavourite(Food food)async{
    var favDoc = await FirebaseFirestore.instance.collection('favouriteFood').doc(FirebaseAuth.instance.currentUser!.uid).get();
    return favDoc.data()?.containsKey(food.id);
  }

  static Future<dynamic> addToFavourites(Food food)async{
    var favDoc = await FirebaseFirestore.instance.collection('favouriteFood').doc(FirebaseAuth.instance.currentUser!.uid);
    Map <String, dynamic> foodMap = {food.id : null};
    favDoc.update(foodMap);
  }

  static Future<dynamic> removeFromFavourites(Food food)async{
    var favDoc = await FirebaseFirestore.instance.collection('favouriteFood').doc(FirebaseAuth.instance.currentUser!.uid);
    favDoc.update({food.id : FieldValue.delete()});
  }

  static Future<dynamic> getAllFavourites(String uid) async{
    var favDoc = FirebaseFirestore.instance.collection('favouriteFood').doc(FirebaseAuth.instance.currentUser!.uid);
    var foodDoc = FirebaseFirestore.instance.collection('foodCollection');
    //LIST OF FAVE FOODS
    List<Map<String,dynamic>> favourites = [];
    //GET FIRST AND ONLY USER FAVOURITES DOC
    var favDoc2 = await favDoc.snapshots().first;
    //GET ALL DOCS CONTAINING FOODS
    var foodDoc2 = await foodDoc.snapshots().first;
    //FOR EACH DOC CONTAINING FOOD CHECK IF USER FAVOURITE LIST CONTAINS ITS ID
    foodDoc2.docs.forEach((element) {
      if(favDoc2.data()!.containsKey(element['id'])){
        favourites.add(element.data());
      }
    });

    return favourites;
  }

  static Future<dynamic> getMyFridge(String uid) async{
    var foodDoc = FirebaseFirestore.instance.collection('foodCollection');
    List<Map<String,dynamic>> foods = [];
    var myFoods = await foodDoc.snapshots().first;
    myFoods.docs.forEach((element) {
      if(element['uid'] == uid){
        foods.add(element.data());
      }
    });
    return foods;
  }
  
  static Future<dynamic> getUserRating(String uid) async{
    var userDoc = FirebaseFirestore.instance.collection('usersCollection').doc(uid);
    var user = await userDoc.snapshots().first;
    var rating = user.data()!['rating'];
    print(user.data()!);
    print('rating is $rating');
    return rating;
  }

  static Future<dynamic> getUserRatingsNumber (String uid) async{
    var userDoc = FirebaseFirestore.instance.collection('usersCollection').doc(uid);
    var user = await userDoc.snapshots().first;
    var rating = user.data()!['timesRated'];
    return rating;
  }

  static Future<dynamic> getTopUsers() async{
    List<String> topUsers =[];
    var userCollection = FirebaseFirestore.instance.collection('usersCollection');
    var userDoc = await userCollection.snapshots().first;
    userDoc.docs.forEach((doc) {
      if(doc['rating'] > 4.4 && doc['timesRated'] >50){
        topUsers.add(doc['uid']);
      }
    });
    return topUsers;
  }

  static Future<dynamic> getFoodByRadius() async{
    var foodDoc = FirebaseFirestore.instance.collection('foodCollection');
    List<Food> foods = [];
    var snapFoods = await foodDoc.snapshots().first;
    var temp = snapFoods.docs.map((e) => Food.fromJSON(e.data())).toList();
    temp.forEach((element) {
      if(calculateDistance(element.location.longitude, element.location.latitude) <= globals.radius && element.uid != FirebaseAuth.instance.currentUser!.uid){
        foods.add(element);
      }
    });
    print(foods);
    // snapFoods.docs.forEach((element) {
    //   if(element['location'])
    // })
  }




  static double calculateDistance(double longitude, double latitude){
    LocationData locationData = globals.location;
    const R = 6371e3; // metres
    var fi1 = latitude * pi/180; // φ, λ in radians
    var fi2 = locationData.latitude! * pi/180;
    var delta1 = (locationData.latitude!-latitude) * pi/180;
    var delta2 = (locationData.longitude!-longitude) * pi/180;

    var a = sin(delta1/2) * sin(delta1/2) + cos(fi1) * cos(fi2) * sin(delta2/2) * sin(delta2/2);
    var c = 2 * atan2(sqrt(a), sqrt(1-a));

    var d = (R * c)/1000; // in metres
    return d;
  }
}