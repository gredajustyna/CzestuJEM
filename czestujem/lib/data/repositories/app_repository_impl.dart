import 'dart:io';

import 'package:czestujem/data/datasources/fire_auth.dart';
import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';

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



}