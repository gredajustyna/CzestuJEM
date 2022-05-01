import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireAuth {
  static Future<dynamic> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 22;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 23;
      }
    } catch (e) {
      print(e);
    }
    DocumentReference documentReference = FirebaseFirestore.instance.collection("usersCollection").doc(user?.uid);
    Map<String, dynamic> userMap = {
      'uid' : user?.uid,
      'rating' : 0,
      'timesRated' : 0,
      'totalPoints' : 0,
      'name' : user?.displayName!,
      'photoURL' : ''
    };
    documentReference.set(userMap);
    documentReference = FirebaseFirestore.instance.collection("favouriteFood").doc(user?.uid);
    userMap ={};
    documentReference.set(userMap);
    documentReference = FirebaseFirestore.instance.collection("reservationsCollection").doc(user?.uid);
    documentReference.set(userMap);
    documentReference = FirebaseFirestore.instance.collection("usersToRateCollection").doc(user?.uid);
    documentReference.set(userMap);

    return user;
  }

  static Future<dynamic> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 24;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        return 25;
      }else if (e.code == 'too-many-requests'){
        return 26;
      }else{
        print(e.code);
        print(e.message);
      }
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<int> sendResetEmail(String email) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      await auth.sendPasswordResetEmail(email: email);
      return 0;
    }on FirebaseAuthException catch (e) {
      return 1;
    }
  }

  static Future<User> getUser() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser!;
  }

}