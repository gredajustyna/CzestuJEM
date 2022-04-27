import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_bloc.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_event.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../config/themes/colors.dart';
import '../widgets/food_widget.dart';
 class UserProfileView extends StatefulWidget {
   final FireUser user;
   const UserProfileView({Key? key, required this.user}) : super(key: key);

   @override
   State<UserProfileView> createState() => _UserProfileViewState();
 }

 class _UserProfileViewState extends State<UserProfileView> {
   late FireUser user;

   @override
  void initState() {
     user = widget.user;
    super.initState();
  }

   @override
   Widget build(BuildContext context) {
     return BlocProvider.value(
       value: BlocProvider.of<GetFridgeBloc>(context)..add(GetMyFridge(user.uid)),
       child: Scaffold(
         appBar: _buildAppbar(),
         body: _buildBody(),
       ),
     );
   }


   PreferredSizeWidget _buildAppbar(){
     return AppBar(
       elevation: 0,
       centerTitle: true,
       backgroundColor: foodBlueGreen,
       title:  Text(
         user.name,
         style: TextStyle(
           color: Colors.white,
           fontWeight: FontWeight.bold,
         ),
       ),
     );
   }

   Widget _buildBody(){
     return Column(
       children: [
         Expanded(
         flex:5,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(1.h),
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
                  SizedBox(width: 2.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(user.name,
                        style: TextStyle(
                            color: foodBlueGreen,
                            fontSize: 15.sp
                        ),
                      ),
                      SizedBox(height: 4,),
                      Row(
                        children: [
                          _buildFacesRow(),
                          SizedBox(width: 1.w,),
                          Text(
                            "(${user.timesRated.toString()})",
                            style: TextStyle(
                                color: foodGrey
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
         ),
         Expanded(
           flex: 30,
           child: BlocBuilder<GetFridgeBloc, FridgeState>(
             builder: (context, state) {
               if(state is FridgeDone){
                 return GridView.count(
                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                     crossAxisSpacing: 1.w,
                     crossAxisCount: 2,
                     children: state.fridge!.map((e) => FoodTile(food: e)).toList()
                 );
               }else{
                 return Center(
                   child: SpinKitCircle(
                     color: foodBlueGreen,
                   ),
                 );
               }
             },
           )
         ),

       ],
     );
   }


   Widget _buildFacesRow(){
     var rating = user.rating;
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
