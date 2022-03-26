import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../entities/food.dart';

abstract class AppRepository{
  Future<dynamic> logIn(String email, String password);

  Future<dynamic> register(String email, String name, String password);

  Future<int> resetPassword(String email);

  Future<dynamic> getChatsList(String uid);

  Future<String> getUsernameFromUid(String uid);

  Future<bool?> checkIfFavourite(Food food);

  Future<void> addToFavourites(Food food);

  Future<void> removeFromFavourites(Food food);

  Future<List<Food>> getAllFavourites(String uid);

  Future<List<Food>> getMyFood(String uid);

  Future<dynamic> getUserRating(String uid);

  Future<dynamic> addFood(String foodFileName, File foodImageFile, Food food);

  Future<dynamic> getFoodByRadius();
}