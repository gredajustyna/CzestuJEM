import 'package:czestujem/config/themes/colors.dart';
import 'package:czestujem/data/datasources/fire_auth.dart';
import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_bloc.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_event.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../../injector.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);



  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late List listItems;
  String? photoURL = FirebaseAuth.instance.currentUser?.photoURL;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    listItems=[
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        child: Row(
          children: [
            photoURL != null ?
            CircleAvatar(
              backgroundImage: NetworkImage(photoURL!),
              radius: 30,
              backgroundColor: Colors.transparent,
            )
                :
            CircleAvatar(
              child: Icon(LineIcons.userCircle,
                size: 100,
                color: foodBlueGreen,
              ),
              radius: 50,
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 2.w,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user!.displayName!,
                  style: TextStyle(
                    color: foodBlueGreen,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4,),
                _buildFacesRow()
              ],
            )
          ],
        ),
      ),
      ListTile(
        leading: Icon(LineIcons.gifts),
        title: Text("Moje rezerwacje",
          style: TextStyle(
            color: foodGrey,
          ),
        ),
      ),
      GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, '/favourites');
        },
        child: ListTile(
          leading: Icon(LineIcons.heart),
          title: Text("Ulubione",
            style: TextStyle(
              color: foodGrey,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, '/fridge');
        },
        child: ListTile(
          leading: Icon(LineIcons.utensils),
          title: Text("Moja lodówka",
            style: TextStyle(
              color: foodGrey,
            ),
          ),
        ),
      ),
      ListTile(
        leading: Icon(LineIcons.smilingFace),
        title: Text("Oceń użytkowników",
          style: TextStyle(
            color: foodGrey,
          ),
        ),
      ),
      GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, '/settings');
        },
        child: ListTile(
          leading: Icon(LineIcons.cog),
          title: Text("Ustawienia",
            style: TextStyle(
              color: foodGrey,
            ),
          ),
        ),
      ),
      InkWell(
        onTap: (){
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          FirebaseAuth.instance.signOut();
        },
        child: ListTile(
          leading: Icon(LineIcons.doorOpen,
            color: foodBlueGreen,
          ),
          title: Text("Wyloguj",
            style: TextStyle(
              color: foodBlueGreen,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (blocContext){
        return RatingBloc(injector());
      },
      child: Builder(
        builder: (blocContext) {
          return BlocProvider.value(
            value: BlocProvider.of<RatingBloc>(blocContext)..add(GetUserRating(FirebaseAuth.instance.currentUser!.uid)),
            child: SafeArea(
              child: Container(
                  child: _buildOptionsList()
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildOptionsList(){
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        print(listItems.length);
        return listItems[index];
      },
      separatorBuilder: (context, index) {
        return Divider(
          indent: 0,
        );
      },
      itemCount: listItems.length,
    ) ;
  }

  Widget _buildFacesRow(){
    return BlocBuilder<RatingBloc, RatingState>(
      builder: (context, state) {
      if(state is RatingDone){
        var rating = state.rating!;
        print(state.rating);
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
    });
  }

}


