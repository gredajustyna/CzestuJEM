import 'package:czestujem/presentation/blocs/food_bloc/delete_food_bloc.dart';
import 'package:czestujem/presentation/blocs/food_bloc/delete_food_state.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_bloc.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_event.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_state.dart';
import 'package:czestujem/presentation/widgets/food_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

import '../../../config/themes/colors.dart';

class FridgeView extends StatefulWidget {
  const FridgeView({Key? key}) : super(key: key);

  @override
  _FridgeViewState createState() => _FridgeViewState();
}

class _FridgeViewState extends State<FridgeView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GetFridgeBloc>(context)..add(GetMyFridge(FirebaseAuth.instance.currentUser!.uid)),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppbar(),
        body: BlocListener<DeleteFoodBloc, DeleteFoodState>(
          listener: (context, state) {
           if(state is DeleteFoodDone){
             setState(() {

             });
           }
          },
          child: BlocBuilder<GetFridgeBloc, FridgeState>(
            builder: (context, state){
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
        'Moja lodówka',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> temp() async{

  }
}
