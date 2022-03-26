import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_bloc.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_event.dart';
import 'package:czestujem/presentation/widgets/food_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

import '../../../config/themes/colors.dart';
import '../../../data/datasources/fire_base.dart';
import '../../blocs/favourite_bloc/favourite_state.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({Key? key}) : super(key: key);

  @override
  _FavouritesViewState createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GetFavouritesBloc>(context)..add(GetAllFavourites(FirebaseAuth.instance.currentUser!.uid)),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppbar(),
        body: BlocBuilder<GetFavouritesBloc, GetFavouritesState>(
          builder: (context, state){
            if(state is GetFavouritesDone){
              return GridView.count(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  crossAxisSpacing: 1.w,
                  crossAxisCount: 2,
                  children: state.foods!.map((e) => FoodTile(food: e)).toList()
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
    );
  }

  PreferredSizeWidget _buildAppbar(){
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: foodBlueGreen,
      title: const Text(
        'Ulubione',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
