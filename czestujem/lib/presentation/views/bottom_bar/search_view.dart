import 'dart:math';
import 'package:czestujem/core/utils/globals.dart' as globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:czestujem/presentation/blocs/search_bloc/search_event.dart';
import 'package:czestujem/presentation/blocs/search_bloc/search_state.dart';
import 'package:czestujem/presentation/widgets/food_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';

import '../../../config/themes/colors.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> dropDown = <String>["Odległość - od najbliższych", "Odległość - od najdalszych", "Alfabetycznie"];


  @override
  void initState() {


  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 90.w,
                  child: Theme(
                    data: ThemeData(
                      colorScheme: ThemeData().colorScheme.copyWith(
                        primary: foodBlueGreen,
                      ),
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                    child: TextFormField(
                      //EDIT TEXT CONTROLLER
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(
                          color: foodBlueGreen,
                        ),
                        fillColor: foodLightBlue,
                        labelText: "szukaj",
                        prefixIcon: Icon(LineIcons.search, size: 24),
                        focusColor: foodBlueGreen,
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: foodGrey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: foodBlueGreen,
                            width: 2.0,
                          ),
                        ),
                      ),
                      controller: _searchController,
                      style: TextStyle(
                        color: foodGrey,
                      ),
                      onFieldSubmitted: (String value){

                      },
                      onChanged: (String value){
                        BlocProvider.of<SearchBloc>(context).add(SearchFood(value));
                      },
                    ),
                  ),
                ),
              ),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state){
                  if(state is SearchDone){
                    if(state.foods!.length ==0){
                      return Column(
                        children: [
                          Icon(LineIcons.timesCircle,
                            color: foodGrey,
                            size: 60,
                          ),
                          Text('Ups, niczego nie znaleźliśmy!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: foodGrey,
                              fontSize: 20.sp
                            ),
                          ),
                          Text('Może masz ochotę na coś innego?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: foodGrey,
                                fontSize: 15.sp
                            ),
                          ),
                        ],
                      );
                    }else{
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: DropdownButton<String>(
                                underline: Container(),
                                icon: Icon(LineIcons.sortAmountUp,color: foodGrey),
                                items: dropDown.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              onChanged: (value){
                                if(value == 'Odległość - od najbliższych'){
                                  state.foods!.sort((a, b) => calculateDistance(a.location.longitude, a.location.latitude).compareTo(calculateDistance(b.location.longitude, b.location.latitude)));
                                }
                                if(value == 'Odległość - od najdalszych'){
                                  state.foods!.sort((a, b) => calculateDistance(a.location.longitude, a.location.latitude).compareTo(calculateDistance(b.location.longitude, b.location.latitude)));
                                }
                                if(value == 'AlfaBetycznie'){
                                  state.foods!.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                                }
                              },
                              isExpanded: true,
                            ),
                          ),
                          GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              crossAxisSpacing: 1.w,
                              crossAxisCount: 2,
                              children: state.foods!.map((e) => FoodTile(food: e)).toList()
                          ),
                        ],
                      );
                    }
                  }else if(state is SearchInitial){
                    return Column(
                      children: [
                        Icon(LineIcons.cookieBite,
                          color: foodGrey,
                          size: 60,
                        ),
                        Text('Co chciałbyś dzisiaj zjeść?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: foodGrey,
                              fontSize: 20.sp
                          ),
                        ),
                        Text('Wpisz w okienko wyszukiwania wymarzone jedzenie!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: foodGrey,
                              fontSize: 15.sp
                          ),
                        ),
                      ],
                    );
                  }else{
                    return Center(
                      child: SpinKitCircle(
                        color: foodBlueGreen,
                      ),
                    );
                  }
                },
              ),
            ],
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
