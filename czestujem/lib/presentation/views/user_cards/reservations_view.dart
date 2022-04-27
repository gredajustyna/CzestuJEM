import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/presentation/widgets/reservation_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../../config/themes/colors.dart';
import '../../../data/datasources/fire_base.dart';
import '../../../domain/entities/reservation.dart';

class ReservationsView extends StatefulWidget {
  const ReservationsView({Key? key}) : super(key: key);

  @override
  State<ReservationsView> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView> {
  late Future myFuture;


  @override
  void initState() {
    //reservations();
    super.initState();
    myFuture = getMyReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FutureBuilder(
          future: getMyReservations(),
          builder: (BuildContext context, AsyncSnapshot snap){
            if(snap.hasData){
              print('the snap data is ${snap.data}');
              if(snap.data.length == 0){
                return Column(
                  children: [
                    Icon(LineIcons.timesCircle,
                      color: foodGrey,
                      size: 60,
                    ),
                    Text('Ups, nic tu nie ma!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: foodGrey,
                          fontSize: 20.sp
                      ),
                    ),
                    Text('Zarezerwuj pierwszą porcję już dziś!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: foodGrey,
                          fontSize: 15.sp
                      ),
                    ),
                  ],
                );
              }else{
                return ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (context, index) {
                    return ReservationCard(reservation: snap.data[index]);
                });
              }

            }else{
              print(snap.data);
              return Text('no data');
            }
          }
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
        'Moje rezerwacje',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Future<void> reservations() async{
  //   var list = await FireBase.getMyReservations();
  //   print(list);
  // }

  Future<dynamic> getMyReservations() async{
    List<Reservation> reservations = [];
    var food;
    var resDoc = await FirebaseFirestore.instance.collection('reservationsCollection').doc(FirebaseAuth.instance.currentUser!.uid).collection('food').get();
    //var foodCol = await resDoc.collection('food').get();
    await Future.forEach(resDoc.docs, (QueryDocumentSnapshot element) async{
      //print((element['date']));
        food = await FireBase.getFoodById(element['id']);
        var reservation = Reservation(food, element['id'], element['date'].toDate());
        reservations.add(reservation);
    });
    return reservations;
  }
}
