import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_bloc.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_state.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';


import '../../config/themes/colors.dart';
import '../../data/datasources/fire_base.dart';
import '../../domain/entities/message.dart';
import '../blocs/messages_bloc/messages_event.dart';

class UserChatView extends StatefulWidget {
  final FireUser user;
  const UserChatView({Key? key, required this.user}) : super(key: key);

  @override
  State<UserChatView> createState() => _UserChatViewState();
}

class _UserChatViewState extends State<UserChatView> {
  late FireUser user;
  late String docId;
  late List<Message> messages;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    user = widget.user;
    getDocId();
    super.initState();


  }

  Future<void> getDocId() async{
    docId =  await FireBase.getConversationDocId(user);
  }

  @override
  Widget build(BuildContext context) {
    getDocId();
    return _buildChat();
    //   Scaffold(
    //   bottomNavigationBar: _buildBottomBar(),
    //   backgroundColor: Colors.grey[100],
    //   appBar: _buildAppbar(),
    //   body: BlocProvider.value(
    //     value: BlocProvider.of<MessagesBloc>(context)..add(GetAllMessages(user)),
    //     child: BlocBuilder<MessagesBloc, MessagesState>(
    //       builder: (context, state) {
    //         if(state is MessagesDone){
    //           return ListView.builder(
    //             reverse: true,
    //             itemCount: state.messages!.length,
    //             itemBuilder: (context, index) {
    //               bool isSender = state.messages![index].from == FirebaseAuth.instance.currentUser!.uid;
    //               return Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
    //                 child: ChatBubble(
    //                   clipper: isSender ? ChatBubbleClipper1(type: BubbleType.sendBubble) : ChatBubbleClipper1(type: BubbleType.receiverBubble),
    //                   backGroundColor: isSender ? foodBlueGreen : foodGrey,
    //                   alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    //                   child: Column(
    //                     children: [
    //                       Text(state.messages![index].content,
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                       Text(DateFormat('kk:mm').format(state.messages![index].sent),
    //                         style: TextStyle(
    //                             fontSize: 10.sp,
    //                             color: Colors.grey[400]
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             }
    //           );
    //         }else{
    //           return Center(
    //             child: SpinKitCircle(
    //               color: foodBlueGreen,
    //             ),
    //           );
    //         }
    //       }
    //     ),
    //   ),
    // );
  }

  Widget _buildChat(){
    return Scaffold(
      bottomNavigationBar: _buildBottomBar(),
        backgroundColor: Colors.grey[100],
        appBar: _buildAppbar(),
      body: FutureBuilder(
        future: FireBase.getConversationDocId(user),
        builder: (BuildContext context, AsyncSnapshot snap){
          if(snap.hasData){
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection("chats").doc(snap.data).collection("messages").orderBy("sent", descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    return ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        bool isSender = document.get('from') == FirebaseAuth.instance.currentUser!.uid;
                        var data = document.data()!;
                        var message = document.data;
                        print(document.toString());
                        //print(data['message']);
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
                          child: ChatBubble(
                            clipper: isSender ? ChatBubbleClipper1(type: BubbleType.sendBubble) : ChatBubbleClipper1(type: BubbleType.receiverBubble),
                            backGroundColor: isSender ? foodBlueGreen : foodGrey,
                            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                            child: Column(
                              children: [
                                Text(document.get('content'),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(DateFormat('kk:mm').format(document.get('sent').toDate()),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey[400]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  else{
                    return Center(
                      child: SpinKitCircle(
                        color: foodBlueGreen,
                      ),
                    );
                  }
                }
            );
          }else{
            return Center(
              child: SpinKitCircle(
                color: foodBlueGreen,
              ),
            );
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(){
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: foodBlueGreen,
      title: Text(
        user.name,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomBar(){
    return Row(
      children: [
        IconButton(
          onPressed: (){
            Message message = new Message(_messageController.text, DateTime.now(), FirebaseAuth.instance.currentUser!.uid, false);
            Map<String, dynamic> messageMap = {'message' : message, 'user': user};
            BlocProvider.of<MessagesBloc>(context).add(SendMessage(messageMap));
            _messageController.clear();
            //FireBase.sendMessage(message, user);
          },
          icon: Icon(LineIcons.paperPlane, color: foodGrey,)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.w),
          child: Container(
            width: 80.w,
            child: Theme(
              data: ThemeData(
                colorScheme: ThemeData().colorScheme.copyWith(
                  primary: foodBlueGreen,
                ),
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
              child: TextFormField(
                //EDIT TEXT CONTROLLER
                decoration: InputDecoration(
                  floatingLabelStyle: TextStyle(
                    color: foodBlueGreen,
                  ),
                  fillColor: foodLightBlue,
                  labelText: "Napisz wiadomość",
                  //prefixIcon: Icon(LineIcons.envelope, size: 24),
                  focusColor: foodBlueGreen,
                  contentPadding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: foodGrey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: foodBlueGreen,
                      width: 2.0,
                    ),
                  ),
                ),
                controller: _messageController,
                style: TextStyle(
                  color: foodGrey,
                ),
                onFieldSubmitted: (String value){

                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
