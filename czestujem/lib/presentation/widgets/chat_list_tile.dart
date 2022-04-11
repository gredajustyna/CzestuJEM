import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/presentation/views/user_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../config/themes/colors.dart';

class ChatListTile extends StatefulWidget {
  final FireUser user;
  const ChatListTile({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  late FireUser user;

  @override
  void initState() {
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserChatView(user: user)),);
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                  style: TextStyle(
                    color: foodBlueGreen,
                    fontSize: 15.sp,

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
