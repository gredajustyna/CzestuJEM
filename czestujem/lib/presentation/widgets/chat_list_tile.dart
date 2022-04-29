import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/injector.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_event.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_state.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_bloc.dart';
import 'package:czestujem/presentation/views/user_chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../config/themes/colors.dart';
import '../../domain/entities/message.dart';
import '../blocs/messages_bloc/messages_state.dart';
import 'package:intl/intl.dart';


class ChatListTile extends StatefulWidget {
  final FireUser user;
  const ChatListTile({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  late FireUser user;
  late Message lastMessage;

  @override
  void initState() {
    user = widget.user;
    getLastMessage();
  }

  Future<void> getLastMessage() async{
    var mes = await FireBase.getLastMessage(user);
    lastMessage = mes;
    print(lastMessage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetLastMessageBloc>(
      create: (messageContext){
        return GetLastMessageBloc(injector());
      },
      child: Builder(
        builder: (messageContext) {
          return BlocProvider.value(
            value: BlocProvider.of<GetLastMessageBloc>(messageContext)..add(GetLastMessage(user)),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserChatView(user: user)),).then((value) {
                  setState(() {

                  });
                });
                //FireBase.getMessages(user);
              },
              child: Card(
                child: Row(
                  children: [
                    Container(
                      child:  user.photoURL != "" ?
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.photoURL),
                        radius: 30,
                        backgroundColor: Colors.transparent,
                      ) :
                      CircleAvatar(
                        child: Icon(LineIcons.userCircle,
                          size: 60,
                          color: foodBlueGreen,
                        ),
                        radius: 30,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name,
                            style: TextStyle(
                              color: foodBlueGreen,
                              fontSize: 15.sp,

                            ),
                          ),
                          BlocBuilder<GetLastMessageBloc, GetLastMessageState>(
                            builder: (context, state) {
                              if(state is GetLastMessageDone){
                                print(state.lastMessage!.sent.hour);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(state.lastMessage!.content,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: (state.lastMessage!.seen || state.lastMessage!.from == FirebaseAuth.instance.currentUser!.uid) ? FontWeight.normal : FontWeight.bold,
                                          color: (state.lastMessage!.seen || state.lastMessage!.from == FirebaseAuth.instance.currentUser!.uid) ? foodGrey : foodBlueGreen
                                        ),
                                      ),
                                    ),
                                    Text(state.lastMessage!.sent.hour == 0 ? DateFormat('kk:mm').format(state.lastMessage!.sent).replaceRange(0, 2, '00') : DateFormat('kk:mm').format(state.lastMessage!.sent),
                                      style: TextStyle(
                                          fontWeight: (state.lastMessage!.seen || state.lastMessage!.from == FirebaseAuth.instance.currentUser!.uid) ? FontWeight.normal : FontWeight.bold,
                                          color: (state.lastMessage!.seen || state.lastMessage!.from == FirebaseAuth.instance.currentUser!.uid) ? foodGrey : foodBlueGreen
                                      ),
                                    ),
                                  ],
                                );
                              }
                              else{
                                return Container();
                              }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
