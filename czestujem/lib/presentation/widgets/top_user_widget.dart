import 'package:czestujem/presentation/blocs/get_username_bloc/get_username_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../config/themes/colors.dart';
import '../../domain/entities/fireuser.dart';

class TopUserWidget extends StatefulWidget {
  final FireUser user;
  const TopUserWidget({Key? key, required this.user}) : super(key: key);

  @override
  _TopUserWidgetState createState() => _TopUserWidgetState();
}

class _TopUserWidgetState extends State<TopUserWidget> {
  String previousUsername ='';
  late FireUser user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: foodOrange,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        child: Center(
          child: Column(
            children: [
              Container(
                child:  user.photoURL != '' ?
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL),
                  radius: 40,
                  backgroundColor: Colors.transparent,
                ) :
                const CircleAvatar(
                  child: Icon(LineIcons.userCircle,
                    size: 80,
                    color: foodBlueGreen,
                  ),
                  radius: 40,
                  backgroundColor: Colors.transparent,
                ),
              ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(user.name,
                    style: TextStyle(
                      color: foodBlueGreen,
                      letterSpacing: 2,
                      fontSize: 15.sp,
                    ),
               ),
                ),
              Row(
                children: [
                  _buildFacesRow(user.rating),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Text(
                      '(${user.timesRated})',
                      style: TextStyle(
                        color: foodGrey,
                      ),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }






  Widget _buildFacesRow(double rating){
    if(rating >=4.5){
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: foodBlueGreen,
            ),
            child: Icon(LineIcons.cryingFace),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodLightBlue,
            ),
            child: Icon(LineIcons.frowningFace,),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  Colors.yellow,
            ),
            child: Icon(LineIcons.neutralFace),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodLightOrange,
            ),
            child: Icon(LineIcons.smilingFace,),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodOrange,
            ),
            child: Icon(LineIcons.grinningFace),
          ),
        ],
      );
    }else if(rating <4.5 && rating >=3.5){
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: foodBlueGreen,
            ),
            child: Icon(LineIcons.cryingFace),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodLightBlue,
            ),
            child: Icon(LineIcons.frowningFace,),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  Colors.yellow,
            ),
            child: Icon(LineIcons.neutralFace),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodLightOrange,
            ),
            child: Icon(LineIcons.smilingFace,),
          ),
          Container(
            child: Icon(LineIcons.grinningFace),
          ),
        ],
      );
    } else if(rating <3.5 && rating >=2.5){
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: foodBlueGreen,
            ),
            child: Icon(LineIcons.cryingFace),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodLightBlue,
            ),
            child: Icon(LineIcons.frowningFace,),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  Colors.yellow,
            ),
            child: Icon(LineIcons.neutralFace),
          ),
          Container(
            child: Icon(LineIcons.smilingFace,),
          ),
          Container(
            child: Icon(LineIcons.grinningFace),
          ),
        ],
      );
    }else if(rating <2.5 && rating >=1.5){
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: foodBlueGreen,
            ),
            child: Icon(LineIcons.cryingFace),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodLightBlue,
            ),
            child: Icon(LineIcons.frowningFace,),
          ),
          Container(
            child: Icon(LineIcons.neutralFace),
          ),
          Container(
            child: Icon(LineIcons.smilingFace,),
          ),
          Container(
            child: Icon(LineIcons.grinningFace),
          ),
        ],
      );
    }else if(rating <1.5 && rating >=0.5){
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: foodBlueGreen,
            ),
            child: Icon(LineIcons.cryingFace),
          ),
          Container(
            child: Icon(LineIcons.frowningFace,),
          ),
          Container(
            child: Icon(LineIcons.neutralFace),
          ),
          Container(
            child: Icon(LineIcons.smilingFace,),
          ),
          Container(
            child: Icon(LineIcons.grinningFace),
          ),
        ],
      );
    }else{
      return Row(
        children: [
          Container(
            child: Icon(LineIcons.cryingFace),
          ),
          Container(
            child: Icon(LineIcons.frowningFace,),
          ),
          Container(
            child: Icon(LineIcons.neutralFace),
          ),
          Container(
            child: Icon(LineIcons.smilingFace,),
          ),
          Container(
            child: Icon(LineIcons.grinningFace),
          ),
        ],
      );
    }
  }

}
