import 'dart:io';

import 'package:czestujem/data/datasources/fire_auth.dart';
import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/entities/message.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppRepositoryImpl implements AppRepository{
  @override
  Future register(String email, String name, String password) async{
    var result = await FireAuth.registerUsingEmailPassword(name: name, email: email, password: password);
    return result;
  }

  @override
  Future logIn(String email, String password) async{
    var result = await FireAuth.signInUsingEmailPassword(email: email, password: password);
    return result;
  }

  @override
  Future<int> resetPassword(String email) async{
    int result = await FireAuth.sendResetEmail(email);
    return result;
  }

  @override
  Future getChatsList(String uid) async{
    var result =  await FireBase.getChatsList(uid: uid);
    return result;
  }

  @override
  Future<String> getUsernameFromUid(String uid) async{
    var result =  await FireBase.getUsernameFromUid(uid);
    return result;
  }

  @override
  Future<bool?> checkIfFavourite(Food food) async{
    var result =  await FireBase.checkIfFavourite(food);
    return result;
  }

  @override
  Future<void> addToFavourites(Food food) async{
   await FireBase.addToFavourites(food);
  }

  @override
  Future<void> removeFromFavourites(Food food) async{
    await FireBase.removeFromFavourites(food);
  }

  @override
  Future<List<Food>> getAllFavourites(String uid) async{
    List<Food> foods = [];
    var result = await FireBase.getAllFavourites(uid);
    for(var element in result){
      foods.add(Food.fromJSON(element));
    }
    return foods;
  }

  @override
  Future<List<Food>> getMyFood(String uid) async{
    List<Food> foods = [];
    var result = await FireBase.getMyFridge(uid);
    for(var element in result){
      foods.add(Food.fromJSON(element));
    }
    return foods;
  }

  @override
  Future getUserRating(String uid) async{
    var result = await FireBase.getUserRating(uid);
    return result;
  }

  @override
  Future addFood(String foodFileName, File foodImageFile, Food food) async{
    var result = await FireBase.addFood(foodFileName, foodImageFile, food);
    return result;
  }

  @override
  Future getFoodByRadius() async{
    var result = await FireBase.getFoodByRadius();
    return result;
  }

  @override
  Future<void> updateUserData(Map<String, dynamic> data) async{
    await FireBase.updateUserData(data['fileName'], data['imageFile'], data['username']);
  }

  @override
  Future<List<FireUser>> getTopUsers() async{
    var result = await FireBase.getTopUsers();
    return result;
  }

  @override
  Future<List<Food>> searchFood(String name) async{
    var result = await FireBase.searchFood(name);
    return result;
  }

  @override
  Future getConversationUsers() async{
    var result = await FireBase.getConversationUsers();
    return result;
  }

  @override
  Future<List<Message>> getAllMessages(FireUser user) async{
    var result = await FireBase.getMessages(user);
    return result;
  }

  @override
  Future<void> sendMessage(FireUser user, Message message) async{
    await FireBase.sendMessage(message, user);
  }

  @override
  Future<String> getConversationDocId(FireUser user) async{
    var result = await FireBase.getConversationDocId(user);
    return result;
  }

  Future<dynamic> reserveFood(Food food, FireUser user) async {
    var message = Message('Witaj, jestem zainteresowana/y porcją: ${food.name}. Kiedy możemy się spotkać?', DateTime.now(), FirebaseAuth.instance.currentUser!.uid, false);
    await FireBase.sendMessage(message, user);
    await FireBase.updateFoodStatus(food, 'zarezerwowane');
  }

  @override
  Future<FireUser> getUserFromUid(String uid) async{
    var result = await FireBase.getUserFromUid(uid);
    return result;
  }

  @override
  Future<List<FireUser>> getUsersToRate(String uid) async{
    var result = await FireBase.getUsersToRate(uid);
    return result;
  }

  @override
  Future<void> rateUser(FireUser user, double mark) async{
    await FireBase.rateUser(user, mark);
  }

  @override
  Future<void> deleteFood(Food food) async {
    await FireBase.deleteFood(food);
  }

  @override
  Future<Message> getLastMessage(FireUser user) async {
    var result = await FireBase.getLastMessage(user);
    return result;
  }

  @override
  Future<void> deleteRate(FireUser user) async{
    await FireBase.deleteRate(user);
  }

  @override
  Future<void> readMessages(FireUser user) async{
    await FireBase.readMessages(user);
  }



}