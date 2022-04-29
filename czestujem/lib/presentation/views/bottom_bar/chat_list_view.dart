import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/data/datasources/fire_auth.dart';
import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:czestujem/presentation/blocs/conversation_users_bloc/conversation_users_bloc.dart';
import 'package:czestujem/presentation/blocs/conversation_users_bloc/conversation_users_event.dart';
import 'package:czestujem/presentation/blocs/conversation_users_bloc/conversation_users_state.dart';
import 'package:czestujem/presentation/widgets/chat_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';

import '../../../config/themes/colors.dart';
import '../../../domain/entities/fireuser.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ConversationUsersBloc>(context)..add(GetConversationUsers()),
      child: BlocBuilder<ConversationUsersBloc, ConversationUsersState>(
        builder: (context, state) {
          if(state is ConversationUsersDone){
            return ListView.builder(
              itemCount: state.users!.length,
              itemBuilder: (context, index){
              return ChatListTile(user: state.users![index]);
            });
          }else{
            return Center(
              child: SpinKitCircle(
                color: foodBlueGreen,
              ),
            );
          }
      }),
    );
  }


}
