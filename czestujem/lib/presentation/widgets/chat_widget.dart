import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/config/themes/colors.dart';
import 'package:czestujem/data/datasources/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  final secondUid;
  final secondName;
  const ChatWidget({Key? key, required this.secondUid, required this.secondName}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late final secondUid;
  late final secondName;
  var chatDocumentId;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    secondUid = widget.secondUid;
    secondName = widget.secondName;
    chats.where('users', isEqualTo: {secondUid : null, currentUserId: null} )
    .limit(1).get().then((QuerySnapshot querySnapshot){
      if(querySnapshot.docs.isNotEmpty){
        chatDocumentId = querySnapshot.docs.single.id;
      }else{
        chats.add({
          'users':[currentUserId, secondUid]
        }).then((value) => {
          chatDocumentId = value
        });
      }
    }).catchError((error) {})
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: secondName,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chats").doc(chatDocumentId).collection("messages").orderBy("createdOn", descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Text("Coś poszło nie tak!"),
            );
          }
          if(snapshot.hasData){
            var data;
            return Container(
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        children: snapshot.data!.docs.map(
                              (DocumentSnapshot document) {
                            data = document.data()!;
                            print(document.toString());
                            print(data['message']);
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: BubbleNormal(
                                isSender: getSender(data['from']),
                                color: getSender(data['from']) ? foodBlueGreen : foodGrey,
                                text: data['message'],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                          ),
                        ),
                        RawMaterialButton(
                          onPressed: (){
                            sendMessage(_messageController.text);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text("Coś poszło nie tak!"),
            );
          }
          return Center(
            child: Text("Coś poszło nie tak!"),
          );
        }
      ),
    );
  }

  void sendMessage(String message) {
    if (message == '') return;
    chats.doc(chatDocumentId).collection('messages').add({
      'sent': FieldValue.serverTimestamp(),
      'from': currentUserId,
      'content': message
    }).then((value) {
      _messageController.text = '';
    });
  }

  bool getSender(String from){
    if(from == currentUserId){
      return true;
    }
    return false;
  }

}
