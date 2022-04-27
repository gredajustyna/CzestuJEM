import 'dart:math';

import 'package:czestujem/config/themes/colors.dart';
import 'package:czestujem/data/datasources/fire_auth.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_bloc.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_event.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_state.dart';
import 'package:czestujem/presentation/blocs/top_users_bloc/top_users_bloc.dart';
import 'package:czestujem/presentation/blocs/top_users_bloc/top_users_event.dart';
import 'package:czestujem/presentation/blocs/top_users_bloc/top_users_state.dart';
import 'package:czestujem/presentation/widgets/food_widget.dart';
import 'package:czestujem/presentation/widgets/top_user_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:czestujem/core/utils/globals.dart' as globals;

import '../../../data/datasources/fire_base.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late User user;

  @override
  void initState(){
    user = FirebaseAuth.instance.currentUser!;
    if(user.photoURL == null){
      print('photo is null');
    }
    getUser();
  }

  Future<void> getUser() async{
    FireBase.getTopUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<TopUsersBloc>(context)..add(GetTopUsers()),
      child: BlocProvider.value(
        value: BlocProvider.of<FoodByRadiusBloc>(context)..add(GetFoodByRadius()),
        child: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 7.h,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70.w,
                            child: Text(
                              "Na co masz dzisiaj ochotę, ${user.displayName!}?",
                              style: TextStyle(
                                color: foodBlueGreen,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            LineIcons.utensils,
                            color: foodBlueGreen,
                            size: 50,
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        child: Text(
                          "Polecane:",
                          style: TextStyle(
                            color: foodOrange,
                            fontSize: 15.sp,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 30.h,
                      child: BlocBuilder<FoodByRadiusBloc, FoodByRadiusState>(
                        builder: (context, state) {
                          if(state is FoodByRadiusDone){
                           return ListView.builder(
                             scrollDirection: Axis.horizontal,
                             itemCount: state.foods!.length > 5 ? 5 : state.foods!.length,
                             itemBuilder: (BuildContext context, int index){
                               return FoodTile(food: state.foods![index]);
                             },
                           );
                          }else{
                            return SpinKitCircle(
                              color: foodBlueGreen,
                            );
                          }
                        }
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        child: Text(
                          "Top użytkownicy:",
                          style: TextStyle(
                            color: foodOrange,
                            fontSize: 15.sp,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 30.h,
                      child: BlocBuilder<TopUsersBloc, TopUsersState>(
                        builder: (context, state) {
                          if(state is TopUsersDone){
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.users!.length > 5 ? 5 : state.users!.length,
                              itemBuilder: (BuildContext context, int index){
                                return TopUserWidget(user: state.users![index]);
                              },
                            );
                          }else{
                            return SpinKitCircle(
                              color: foodBlueGreen,
                            );
                          }
                        }
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        child: Text(
                          "Dla Ciebie:",
                          style: TextStyle(
                            color: foodOrange,
                            fontSize: 15.sp,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<FoodByRadiusBloc, FoodByRadiusState>(
                        builder: (context, state) {
                          if(state is FoodByRadiusDone){
                            return GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              crossAxisSpacing: 1.w,
                              crossAxisCount: 2,
                              children: state.foods!.map((e) => FoodTile(food: e)).toList()
                            );
                          }else{
                            return SpinKitCircle(
                              color: foodBlueGreen,
                            );
                          }
                        }
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

  static Route<dynamic> _createAnimatedRouteRight(Widget view) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => view,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0);
        const end = Offset(0, 0);
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }


}
