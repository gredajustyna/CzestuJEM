import 'package:czestujem/domain/entities/reservation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';


import '../../domain/entities/food.dart';

class ReservationCard extends StatefulWidget {
  final Reservation reservation;
  const ReservationCard({Key? key, required this.reservation}) : super(key: key);

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  late Reservation reservation;
  final f = DateFormat('dd-MM-yyyy hh:mm');


  @override
  void initState() {
    reservation = widget.reservation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            height: 20.h,
            width: 30.w,
            child: reservation.food.photoURL != '' ?
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    child: Image.network(reservation.food.photoURL, fit: BoxFit.cover)))
             : Icon(LineIcons.camera, size: 40,),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('nazwa: ${reservation.food.name}'),
                Text('data: ${f.format(reservation.time)}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
