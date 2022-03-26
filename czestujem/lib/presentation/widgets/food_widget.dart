import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/config/themes/colors.dart';
import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:czestujem/injector.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_bloc.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_event.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_state.dart';
import 'package:czestujem/presentation/blocs/get_username_bloc/get_username_bloc.dart';
import 'package:czestujem/presentation/blocs/get_username_bloc/get_username_event.dart';
import 'package:czestujem/presentation/blocs/get_username_bloc/get_username_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:czestujem/core/utils/globals.dart' as globals;
import 'dart:math';

import '../../domain/entities/food.dart';
import '../views/food_view.dart';


class FoodTile extends StatefulWidget {
  final Food food;
  const FoodTile({Key? key, required this.food}) : super(key: key);

  @override
  _FoodTileState createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  late Food food;
  String previousUsername ='';


  @override
  void initState() {
    food = widget.food;
  }




  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetUsernameBloc>(
      create: (usernameBlocContext){
        return GetUsernameBloc(injector());
      },
      child: BlocProvider<CheckFavouriteBloc>(
        create: (usernameBlocContext){
          return CheckFavouriteBloc(injector());
        },
        child: BlocProvider<FavouriteBloc>(
          create: (usernameBlocContext){
            return FavouriteBloc(injector(), injector());
          },
          child: Builder(
            builder: (usernameBlocContext) {
              return BlocProvider.value(
                value: BlocProvider.of<GetUsernameBloc>(usernameBlocContext)..add(GetUsername(food.uid)),
                child: BlocProvider.value(
                  value: BlocProvider.of<CheckFavouriteBloc>(usernameBlocContext)..add(CheckIfFavourite(food)),
                  child: BlocListener<FavouriteBloc, AddRemoveFavouritesState>(
                    listener: (context, state){
                      if(state is AddRemoveFavouritesDone){
                        setState(() {

                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(1.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        height: 30.h,
                        width: 40.h,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0,0,0, 2.w),
                          child: Column(
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(usernameBlocContext).push(MaterialPageRoute(builder: (BuildContext context) => FoodView(food: food, context: usernameBlocContext,)));
                                  },
                                  child: Hero(
                                    tag: food.id,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                      ),
                                      height: 25.h,
                                      width: 40.h,
                                      child: food.photoURL != '' ?
                                      Stack(
                                        fit: StackFit.expand,
                                        children:[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.network(food.photoURL, fit: BoxFit.cover)),
                                          Positioned(
                                            right: 6,
                                            top: 6,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                _buildLikeHeart(usernameBlocContext)
                                              ],
                                            ),
                                          )
                                        ]
                                      ) : Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Icon(LineIcons.camera, size: 40,),
                                              Positioned(
                                                right: 6,
                                                top: 6,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    _buildLikeHeart(usernameBlocContext)
                                                  ],
                                                ),
                                              )
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                child: Text(food.name,
                                  style: TextStyle(
                                    color: foodGrey,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              BlocBuilder<GetUsernameBloc, GetUsernameState>(
                                builder: (context, state){
                                  if(state is GetUsernameDone){
                                    previousUsername = state.username!;
                                    return Text(state.username!,
                                      style: TextStyle(
                                          color: foodGrey
                                      ),
                                    );
                                  }else{
                                    return Text(previousUsername,
                                      style: TextStyle(
                                          color: foodGrey
                                      ),
                                    );
                                  }
                              }),
                              Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LineIcons.mapMarker,
                                    size: 15,
                                      color: foodBlueGreen,
                                    ),
                                    Text('${calculateDistance(food.location.longitude, food.location.latitude)}km',
                                      style: TextStyle(
                                        color: foodBlueGreen
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  String calculateDistance(double longitude, double latitude){
    LocationData locationData = globals.location;
    const R = 6371e3; // metres
    var fi1 = latitude * pi/180; // φ, λ in radians
    var fi2 = locationData.latitude! * pi/180;
    var delta1 = (locationData.latitude!-latitude) * pi/180;
    var delta2 = (locationData.longitude!-longitude) * pi/180;

    var a = sin(delta1/2) * sin(delta1/2) + cos(fi1) * cos(fi2) * sin(delta2/2) * sin(delta2/2);
    var c = 2 * atan2(sqrt(a), sqrt(1-a));

    var d = (R * c)/1000; // in metres
    return d.toStringAsFixed(1);
  }

  Widget _buildLikeHeart(BuildContext blocContext){
    return BlocBuilder<CheckFavouriteBloc, CheckFavouritesState>(
      builder: (context, state){
        if(state is CheckFavouritesDone){
          return GestureDetector(
            onTap: (){
              if(state.isFavourite!){
                BlocProvider.of<FavouriteBloc>(blocContext).add(RemoveFromFavourites(food));
                BlocProvider.of<GetFavouritesBloc>(context).add(GetAllFavourites(FirebaseAuth.instance.currentUser!.uid));
              }else{
                BlocProvider.of<FavouriteBloc>(blocContext).add(AddToFavourites(food));
              BlocProvider.of<GetFavouritesBloc>(context).add(GetAllFavourites(FirebaseAuth.instance.currentUser!.uid));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: state.isFavourite! ?
                Icon(LineIcons.heartAlt, color: foodOrange,)
                    : Icon(LineIcons.heart, color: foodGrey,
                ),
              ),
            ),
          );
        }else{
          return GestureDetector(
            onTap: (){

            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Icon(LineIcons.heart,
                  color: foodGrey,
                ),
              ),
            ),
          );
        }
      },
    );
  }

}
