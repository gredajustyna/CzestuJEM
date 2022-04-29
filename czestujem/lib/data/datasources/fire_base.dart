import 'dart:io';
import 'dart:math';
import 'package:czestujem/core/utils/globals.dart' as globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/entities/message.dart';
import 'package:czestujem/domain/entities/reservation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';


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

  static Future<dynamic> createChat(FireUser user)async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('chats').doc();
    List<String> users = [user.uid, FirebaseAuth.instance.currentUser!.uid];
    documentReference.set({'users' : users});
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

  static Future<FireUser> getUserFromUid(String uid) async{
    late FireUser user;
    var userDoc = await FirebaseFirestore.instance.collection('usersCollection').where('uid', isEqualTo: uid).get();
    userDoc.docs.forEach((element) async{
      user = FireUser.fromJSON(element.data());
      print(user);
    });
    return user;
  }
  
  static Future<dynamic> addFood(dynamic foodFileName, dynamic foodImageFile, Food food) async{
    if(food.photoURL =='1'){
      var uploadTask = await FirebaseStorage.instance.ref(foodFileName).putFile(foodImageFile!).whenComplete(() async =>
      food.photoURL = await FirebaseStorage.instance.ref(foodFileName).getDownloadURL(),
      );
    }else{
      await FirebaseFirestore.instance.collection('foodCollection').add(food.toJson()).catchError((e){return 1;});
    }
  }

  static Future<void> deleteFood(Food food) async{
    var docRef = await FirebaseFirestore.instance.collection('foodCollection').where('id', isEqualTo: food.id).get();
    for(var doc in docRef.docs){
      await doc.reference.delete();
    }
    var favRef = await FirebaseFirestore.instance.collection('favouriteFood').where(food.id, isEqualTo: null).get();
    for(var doc in favRef.docs){
      await doc.reference.update({food.id : FieldValue.delete()});
    }

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
    var myFoods = await foodDoc.get();
    myFoods.docs.forEach((element) {
      if(element['uid'] == uid){
        foods.add(element.data());
      }
    });
    return foods;
  }

  static Future<dynamic> getFoodById(String id) async{
    late var food;
    var foodDoc = await FirebaseFirestore.instance.collection('foodCollection').where('id', isEqualTo: id).get().then((value) {
      print(value.docs.length);
      food = Food.fromJSON(value.docs.single.data());
    });
    return food;
  }


  static Future<dynamic> getMyReservations() async{
    List<Reservation> reservations = [];
    var food;
    var resDoc = await FirebaseFirestore.instance.collection('reservationsCollection').doc(FirebaseAuth.instance.currentUser!.uid).collection('food').get();
    await Future.forEach(resDoc.docs, (QueryDocumentSnapshot element) async{
      food = await FireBase.getFoodById(element['id']);
      var reservation = Reservation(food, element['id'], element['date'].toDate());
      reservations.add(reservation);
    });
    return reservations;
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
    List<FireUser> topUsers =[];
    List<FireUser> users = [];
    var userCollection = FirebaseFirestore.instance.collection('usersCollection');
    var userDoc = await userCollection.snapshots().first;
    users = userDoc.docs.map((e) => FireUser.fromJSON(e.data())).toList();
    for(FireUser user in users){
      if(user.rating > 4.4 && user.timesRated >50){
        topUsers.add(user);
      }
      if(user.uid == FirebaseAuth.instance.currentUser!.uid){
        topUsers.remove(user);
      }
    }
    return topUsers;
  }

  static Future<dynamic> getFoodByRadius() async{
    var foodDoc = FirebaseFirestore.instance.collection('foodCollection');
    List<Food> foods = [];
    var snapFoods = await foodDoc.get();
    var temp = snapFoods.docs.map((e) => Food.fromJSON(e.data())).toList();
    temp.forEach((element) {
      if(calculateDistance(element.location.longitude, element.location.latitude) <= globals.radius && element.uid != FirebaseAuth.instance.currentUser!.uid){
        foods.add(element);
      }
    });
    return foods;
  }

  static Future<void> updateUserData(String fileName, File imageFile, String? username) async{
    String photoURL = '';
    var uploadTask = await FirebaseStorage.instance.ref(fileName).putFile(imageFile).whenComplete(() async =>
    photoURL = await FirebaseStorage.instance.ref(fileName).getDownloadURL(),
    );
    FirebaseAuth.instance.currentUser?.updatePhotoURL(photoURL);
    DocumentReference documentReference = FirebaseFirestore.instance.collection("usersCollection").doc(FirebaseAuth.instance.currentUser?.uid);
    documentReference.update({'photoURL' : photoURL});
    if(username != null){
      FirebaseAuth.instance.currentUser!.updateDisplayName(username);
    }
  }

  static Future<dynamic> searchFood(String name) async{
    var foodDoc = FirebaseFirestore.instance.collection('foodCollection');
    List<Food> foods = [];
    var snapFoods = await foodDoc.get();
    var temp = snapFoods.docs.map((e) => Food.fromJSON(e.data())).toList();
    temp.forEach((element) {
      if(element.name.contains(name)){
        foods.add(element);
      }
    });
    return foods;
  }

  static Future<dynamic> getConversationUsers() async{
    List<FireUser> users =[];
    var chatsDoc = FirebaseFirestore.instance.collection('chats');
    var snapChats = await chatsDoc.snapshots(includeMetadataChanges: true).first;
    var snapData = snapChats.docs.map((e) => e.data());
    for (var element in snapData){
      if(element['users'][0].toString().contains(FirebaseAuth.instance.currentUser!.uid) || element['users'][1].toString().contains(FirebaseAuth.instance.currentUser!.uid)){
        if(element['users'][0].toString().contains(FirebaseAuth.instance.currentUser!.uid)){
          var user = await getUserFromUid(element['users'][1].toString());
          print(user.name);
          users.add(user);
        }else{
          var user = await getUserFromUid(element['users'][0].toString());
          print(user.name);
          users.add(user);
        }
      }
    }
    return users;
  }

  static Future<dynamic> getConversationDocId(FireUser user) async{
    List<String> allDocs=[];
    List<String> rightDocs=[];
    var chatsDoc = FirebaseFirestore.instance.collection('chats');
    var snapChats = await chatsDoc.snapshots().first;
    for (var element in snapChats.docs) {
      allDocs.add(element.reference.id);
    }
    print(allDocs);
    var snapData = snapChats.docs.map((e) => e.data());
    int index = 0;
    for (var element in snapData){
      if((element['users'][0].toString().contains(FirebaseAuth.instance.currentUser!.uid) && element['users'][1].toString().contains(user.uid))
          || (element['users'][1].toString().contains(FirebaseAuth.instance.currentUser!.uid) && element['users'][0].toString().contains(user.uid))){
        rightDocs.add(allDocs.elementAt(index));
      }else{
      }
      index++;
    }
    if(rightDocs.isEmpty){
      DocumentReference documentReference = FirebaseFirestore.instance.collection('chats').doc();
      List<String> users = [user.uid, FirebaseAuth.instance.currentUser!.uid];
      documentReference.set({'users' : users});
      rightDocs.add(documentReference.id);
    }
    print(rightDocs);
    return rightDocs.single;
  }

  static Future<dynamic> getMessages(FireUser user) async{
    CollectionReference chats = FirebaseFirestore.instance.collection("chats");
    String docId = await getConversationDocId(user);
    CollectionReference messages = chats.doc(docId).collection("messages");
    var snapFoods = await messages.get();
    var temp = snapFoods.docs.map((e) => Message.fromJson(e.data() as Map<String, dynamic>)).toList();
    temp.sort((a,b) => a.sent.compareTo(b.sent));
    return temp.reversed.toList();
  }

  static Future<dynamic> getLastMessage(FireUser user) async{
    CollectionReference chats = FirebaseFirestore.instance.collection("chats");
    String docId = await getConversationDocId(user);
    CollectionReference messages = chats.doc(docId).collection("messages");
    var snapFoods = await messages.get();
    var temp = snapFoods.docs.map((e) => Message.fromJson(e.data() as Map<String, dynamic>)).toList();
    temp.sort((a,b) => a.sent.compareTo(b.sent));
    var last = temp.last;
    //var lastMessage = snapFoods.docs.last;
    //var last = Message.fromJson(lastMessage.data() as Map<String, dynamic>);
    return last;
  }

  static Future<void> readMessages(FireUser user) async{
    CollectionReference chats = FirebaseFirestore.instance.collection("chats");
    String docId = await getConversationDocId(user);
    CollectionReference messages = chats.doc(docId).collection("messages");
    var snapFoods = await messages.get();
    Future.forEach(snapFoods.docs, (QueryDocumentSnapshot element) async{
      await element.reference.update({'seen' : true});
    });
  }


  static Future<dynamic> sendMessage(Message message, FireUser user) async{
    CollectionReference chats = FirebaseFirestore.instance.collection("chats");
    String docId = await getConversationDocId(user);
    CollectionReference messages = chats.doc(docId).collection("messages");
    messages.doc().set(message.toJson());
  }

  static Future<void> updateFoodStatus(Food food, String status) async{
    var documentReference = await FirebaseFirestore.instance.collection("foodCollection").where('id', isEqualTo: food.id).get();
    Future.forEach(documentReference.docs, (QueryDocumentSnapshot element) async{
      await element.reference.update({'status' : status});
    });
    // documentReference.docs.forEach((element) async{
    //   await element.reference.update({'status' : status});
    // });

  }

  static Future<String> reserveFood(Food food, FireUser user) async{
    Message message = Message('Witaj, jestem zainteresowana/y porcją: ${food.name}. Kiedy możemy się spotkać?', DateTime.now(), FirebaseAuth.instance.currentUser!.uid, false);
    await FireBase.sendMessage(message, user);
    await FireBase.updateFoodStatus(food, 'zarezerwowane');
    var resDoc = FirebaseFirestore.instance.collection('reservationsCollection').doc(FirebaseAuth.instance.currentUser!.uid).collection('food').doc(food.id);
    print('The resDoc id is ${resDoc.id}');
    resDoc.set({'id' : food.id, 'date' : Timestamp.fromDate(DateTime.now())});
    return '1';
    //var res = Reservation(food, resId.toString(), DateTime.now());
    //await resDoc.set({'id' : resId.toString(), 'date' : Timestamp.fromDate(DateTime.now())});
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

  static Future<List<FireUser>> getUsersToRate(String uid) async{
    List<FireUser> usersToRate = [];
    var usersDoc = FirebaseFirestore.instance.collection('usersToRateCollection').doc(uid);
    var usersDoc2 = await usersDoc.get();
    await Future.forEach(usersDoc2.data()!.keys, (element) async {
      FireUser user = await getUserFromUid(element.toString());
      usersToRate.add(user);
    });
    return usersToRate;
  }

  static Future<void> rateUser(FireUser user, double mark) async{
    var newTimesRated = user.timesRated + 1;
    var newTotalPoints = user.totalPoints + mark;
    var newRating = newTotalPoints/newTimesRated;
    var usersDoc = FirebaseFirestore.instance.collection('usersCollection').doc(user.uid);
    await usersDoc.update({'totalPoints' : newTotalPoints, 'rating' : newRating, 'timesRated' : newTimesRated});
    var usersToRateDoc = FirebaseFirestore.instance.collection('usersToRateCollection').doc(FirebaseAuth.instance.currentUser!.uid);
    await usersToRateDoc.update({user.uid : FieldValue.delete()});
  }

  static Future<void> deleteRate(FireUser user) async{
    var usersToRateDoc = FirebaseFirestore.instance.collection('usersToRateCollection').doc(FirebaseAuth.instance.currentUser!.uid);
    await usersToRateDoc.update({user.uid : FieldValue.delete()});
  }

  static Future<void> deleteReservation(Reservation reservation) async{
    Message message = Message('Witaj, porcja: ${reservation.food.name} jest jednak niedostępna. Przepraszam za kłopot.', DateTime.now(), FirebaseAuth.instance.currentUser!.uid, false);
    await updateFoodStatus(reservation.food, "dostępne");
    
  }

}