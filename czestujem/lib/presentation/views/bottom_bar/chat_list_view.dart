import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/data/datasources/fire_auth.dart';
import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  void initState() {
    CollectionReference chats = FirebaseFirestore.instance.collection("chats");
    chats.where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid).get().then((QuerySnapshot querySnapshot) => {
      if(querySnapshot.docs.isNotEmpty){
        print(querySnapshot.docs[0]),
        print(querySnapshot.docs.length)
      }else{
        print('no chats')
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference chats = FirebaseFirestore.instance.collection("chats");
    return StreamBuilder<QuerySnapshot>(
        stream: chats.where('users.${FirebaseAuth.instance.currentUser!.uid}', isEqualTo: null).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading"),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(itemBuilder: (context, index){
              QueryDocumentSnapshot queryDocumentSnapshot = snapshot.data!.docs[index];
              return ListTile(
                title: Text(queryDocumentSnapshot.data().toString()),
              );
            });
          }
          return Container();
        });
  }


}
