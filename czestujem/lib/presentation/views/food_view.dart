
import 'dart:async';
import 'dart:math';

import 'package:czestujem/data/datasources/fire_base.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_event.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:czestujem/core/utils/globals.dart' as globals;

import '../../config/themes/colors.dart';
import '../../domain/entities/food.dart';
import '../../injector.dart';
import '../blocs/favourite_bloc/favourite_bloc.dart';
import '../blocs/favourite_bloc/favourite_state.dart';
import 'package:intl/intl.dart';

import '../blocs/get_username_bloc/get_username_bloc.dart';
import '../blocs/get_username_bloc/get_username_event.dart';
import '../blocs/get_username_bloc/get_username_state.dart';
import '../blocs/rating_bloc/rating_event.dart';
import '../blocs/rating_bloc/rating_state.dart';



class FoodView extends StatefulWidget {
  final Food food;
  final BuildContext context;
  const FoodView({Key? key, required this.food, required this.context}) : super(key: key);

  @override
  _FoodViewState createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  late Food food;
  bool? isFave = false;
  late BuildContext foodContext;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  Completer<GoogleMapController> _controller = Completer();
  late final _kGooglePlex;
  late Set<Circle> circles;



  @override
  void initState() {
    food = widget.food;
    foodContext = widget.context;
    _kGooglePlex = CameraPosition(
      target: LatLng(food.location.latitude, food.location.longitude),
      zoom: 14.4746,
    );
    circles = Set.from([Circle(
      circleId: CircleId(food.id),
      center: LatLng(food.location.latitude, food.location.longitude),
      radius: 200,
      fillColor: foodLightBlue.withOpacity(0.5),
      strokeColor: foodBlueGreen,
      strokeWidth: 1,
    )]);
    checkIfFave();
    super.initState();
  }

  Future<void> checkIfFave() async{
    bool? result = await FireBase.checkIfFavourite(food);
    isFave = result;
    setState(() {

      print(isFave);
    });
  }

  @override
  Widget build(foodContext) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _buildBody(),
      appBar: _buildAppbar(),
      bottomNavigationBar:_buildBottomAppBar(),
    );
  }


  Widget _buildBody(){
    return BlocProvider(
      create: (favouriteBlocContext){
        return CheckFavouriteBloc(injector());
      },
      child: BlocProvider(
        create: (favouriteBlocContext){
          return FavouriteBloc(injector(), injector());
        },
        child: BlocProvider(
          create: (favouriteBlocContext){
            return RatingBloc(injector());
          },
          child: BlocProvider(
            create: (favouriteBlocContext){
              return GetUsernameBloc(injector());
            },
            child: Builder(
              builder: (favouriteBlocContext) {
                return BlocProvider.value(
                  value: BlocProvider.of<CheckFavouriteBloc>(favouriteBlocContext)..add(CheckIfFavourite(food)),
                  child: BlocProvider.value(
                    value: BlocProvider.of<GetUsernameBloc>(favouriteBlocContext)..add(GetUsername(food.uid)),
                    child: BlocProvider.value(
                      value: BlocProvider.of<RatingBloc>(favouriteBlocContext)..add(GetUserRating(food.uid)),
                      child: BlocListener<FavouriteBloc, AddRemoveFavouritesState>(
                        listener: (context, state){
                          if(state is AddRemoveFavouritesDone){
                            setState(() {

                            });
                          }
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 30.h,
                                child: Hero(
                                  tag: food.id,
                                  child: food.photoURL != '' ?
                                  Stack(
                                      fit: StackFit.expand,
                                      children:[
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              child: Image.network(food.photoURL, fit: BoxFit.cover))),
                                        Positioned(
                                          right: 6,
                                          top: 6,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              _buildLikeHeart(favouriteBlocContext)
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
                                              _buildLikeHeart(favouriteBlocContext)
                                            ],
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: foodBlueGreen,
                                    letterSpacing: 2
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LineIcons.mapMarker,
                                      size: 15,
                                      color: foodBlueGreen,
                                    ),
                                    Text('${calculateDistance(food.location.longitude, food.location.latitude)} km od Ciebie',
                                      style: TextStyle(
                                          color: foodBlueGreen
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: FirebaseAuth.instance.currentUser!.photoURL != null ?
                                        Image.network(FirebaseAuth.instance.currentUser!.photoURL!) :
                                        Icon(LineIcons.userCircle,
                                          size: 60,
                                          color: foodBlueGreen,
                                        ),
                                        radius: 30,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      SizedBox(width: 1.w,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          BlocBuilder<GetUsernameBloc, GetUsernameState>(
                                              builder: (context, state){
                                                if(state is GetUsernameDone){
                                                  return Text(state.username!,
                                                    style: TextStyle(
                                                        color: foodBlueGreen,
                                                      fontSize: 15.sp
                                                    ),
                                                  );
                                                }else{
                                                  return Text('',
                                                    style: TextStyle(
                                                        color: foodGrey
                                                    ),
                                                  );
                                                }
                                              }),
                                          SizedBox(height: 4,),
                                          _buildFacesRow()
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: Container(
                                    width: 90.w,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(LineIcons.breadSlice,
                                              color: foodGrey,
                                            ),
                                            SizedBox(width: 1.w,),
                                            Row(
                                              children: [
                                                Text('Kategoria: ',
                                                  style: TextStyle(
                                                      color: foodGrey
                                                  ),
                                                ),
                                                Text('${food.category}',
                                                  style: TextStyle(
                                                      color: foodBlueGreen
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(LineIcons.calendar,
                                              color: foodGrey,
                                            ),
                                            SizedBox(width: 1.w,),
                                            Row(
                                              children: [
                                                Text('Data ważności: ',
                                                  style: TextStyle(
                                                      color: foodGrey
                                                  ),
                                                ),
                                                Text('${formatter.format(food.expirationDate)}',
                                                  style: TextStyle(
                                                      color: foodBlueGreen
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 90.w,
                                height: 20.h,
                                child: GoogleMap(
                                  initialCameraPosition: _kGooglePlex,
                                  circles: circles,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: Container(
                                  height: MediaQuery.of(context).size.height/5,
                                  child: Text(
                                    food.description,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: foodGrey
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(){
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: foodBlueGreen,
      title: const Text(
        'Podgląd',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLikeHeart(BuildContext context){
    return BlocBuilder<CheckFavouriteBloc, CheckFavouritesState>(
      builder: (context, state){
        if(state is CheckFavouritesDone){
          return GestureDetector(
            onTap: (){
              if(state.isFavourite!){
                BlocProvider.of<FavouriteBloc>(context).add(RemoveFromFavourites(food));
                BlocProvider.of<GetFavouritesBloc>(context).add(GetAllFavourites(FirebaseAuth.instance.currentUser!.uid));
              }else{
                BlocProvider.of<FavouriteBloc>(context).add(AddToFavourites(food));
                BlocProvider.of<GetFavouritesBloc>(context).add(GetAllFavourites(FirebaseAuth.instance.currentUser!.uid));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: isFave! ?
                Icon(LineIcons.heartAlt,
                  size: 50,
                  color: foodOrange,
                )
                    : Icon(LineIcons.heart,
                  size: 50,
                  color: foodGrey,
                ),
              ),
            ),
          );
        }else{
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: isFave! ?
              Icon(LineIcons.heartAlt,
                size: 50,
                color: foodOrange,
              )
                  : Icon(LineIcons.heart,
                size: 50,
                color: foodGrey,
              ),
            ),
          );
        }
      }
    );
  }

  Widget _buildBottomAppBar(){
    if(food.uid == FirebaseAuth.instance.currentUser!.uid){
      return BottomAppBar(
        color: Colors.grey[100],
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {

                },
                child: Row(
                  children: [
                    Icon(LineIcons.times,
                      color: foodOrange,
                    ),
                    Text(
                      'Usuń',
                      style: TextStyle(
                          color: foodOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: foodOrange,
                          width: 2,
                        ),
                      )
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
                ),
              ),
              SizedBox(width: 3.w,),
              ElevatedButton(
                onPressed: () {

                },
                child: Row(
                  children: [
                    Icon(LineIcons.pen,
                      color: foodGrey,
                    ),
                    Text(
                      'Edytuj',
                      style: TextStyle(
                          color: foodGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: foodGrey,
                          width: 2,
                        ),
                      )
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return BottomAppBar(
      color: Colors.grey[100],
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {

              },
              child: Row(
                children: [
                  Icon(LineIcons.bookmark,
                    color: foodBlueGreen,
                  ),
                  Text(
                    'Rezerwuj!',
                    style: TextStyle(
                        color: foodBlueGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp
                    ),
                  ),
                ],
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: foodBlueGreen,
                        width: 2,
                      ),
                    )
                ),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all<double>(0),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
              ),
            ),
          ],
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

  Widget _buildFacesRow(){
    return BlocBuilder<RatingBloc, RatingState>(
        builder: (context, state) {
          if(state is RatingDone){
            print('rating for ${food.uid} is ${state.rating}');
            var rating = state.rating!;
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
