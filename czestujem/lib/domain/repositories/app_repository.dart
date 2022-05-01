import 'dart:io';

import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/domain/entities/message.dart';
import 'package:czestujem/domain/entities/reservation.dart';
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

  Future<void> updateUserData(Map<String, dynamic> data);

  Future<List<FireUser>> getTopUsers();

  Future<List<Food>> searchFood(String name);

  Future<dynamic> getConversationUsers();

  Future<List<Message>> getAllMessages(FireUser user);

  Future<void> sendMessage(FireUser user, Message message);

  Future<String> getConversationDocId(FireUser user);

  Future<FireUser> getUserFromUid(String uid);

  Future<void> reserveFood(Food food, FireUser user);

  Future<List<FireUser>> getUsersToRate(String uid);

  Future<void> rateUser(FireUser user, double mark);

  Future<void> deleteFood(Food food);

  Future<Message> getLastMessage(FireUser user);

  Future<void> deleteRate(FireUser user);

  Future<void> readMessages(FireUser user);

  Future<void> deleteReservation(Reservation reservation);

  Future<void> confirmReservation(Reservation reservation);
}