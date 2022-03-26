import 'dart:math';

import 'package:czestujem/config/themes/colors.dart';
import 'package:czestujem/data/datasources/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return SafeArea(
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
                  child: Container(
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
              ],
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


}
