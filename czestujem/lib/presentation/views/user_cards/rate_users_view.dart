import 'package:czestujem/presentation/blocs/get_users_to_rate_bloc/get_users_to_rate_bloc.dart';
import 'package:czestujem/presentation/blocs/get_users_to_rate_bloc/get_users_to_rate_event.dart';
import 'package:czestujem/presentation/blocs/get_users_to_rate_bloc/get_users_to_rate_state.dart';
import 'package:czestujem/presentation/blocs/rate_user_bloc/rate_user_bloc.dart';
import 'package:czestujem/presentation/blocs/rate_user_bloc/rate_user_state.dart';
import 'package:czestujem/presentation/widgets/rate_user_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../config/themes/colors.dart';

class RateUsersView extends StatefulWidget {
  const RateUsersView({Key? key}) : super(key: key);

  @override
  State<RateUsersView> createState() => _RateUsersViewState();
}

class _RateUsersViewState extends State<RateUsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(),
        body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppbar(){
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: foodBlueGreen,
      title: const Text(
        'Oceń użytkowników',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody(){
    return BlocProvider.value(
      value: BlocProvider.of<GetUsersToRateBloc>(context)..add(GetUsersToRate(FirebaseAuth.instance.currentUser!.uid)),
      child: BlocListener<RateUserBloc, RateUserState>(
          listener: (context, state) {
           if(state is RateUserDone){
             context.loaderOverlay.hide();
             ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Pomyślnie oceniono użytkownika!',
                     style: TextStyle(
                       color: Colors.white,
                     ),
                   ),
                   duration: Duration(milliseconds: 750),
                   backgroundColor: foodBlueGreen,
                 )
             );
             BlocProvider.of<GetUsersToRateBloc>(context).add(GetUsersToRate(FirebaseAuth.instance.currentUser!.uid));
           }else if(state is RateUserError){
             context.loaderOverlay.hide();
             ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Ups, coś poszło nie tak!',
                     style: TextStyle(
                       color: Colors.white,
                     ),
                   ),
                   duration: Duration(milliseconds: 750),
                   backgroundColor: foodOrange,
                 )
             );
           }else if(state is RateUserLoading){
             context.loaderOverlay.show();
           }else if(state is RateUserDeleted){
             context.loaderOverlay.hide();
             ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Pomyślnie usunięto!',
                     style: TextStyle(
                       color: Colors.white,
                     ),
                   ),
                   duration: Duration(milliseconds: 750),
                   backgroundColor: foodBlueGreen,
                 )
             );
           }
           setState(() {

           });
          },
          child: LoaderOverlay(
            overlayColor: foodLightBlue,
            overlayWholeScreen: true,
            overlayWidget: Center(
              child: SpinKitChasingDots(
                color: Colors.white,
                size: 100,
              ),
            ),
            child: BlocBuilder<GetUsersToRateBloc, GetUsersToRateState>(
              builder: (context, state) {
                if(state is GetUsersToRateDone){
                  return ListView.builder(
                    itemCount: state.users!.length,
                    itemBuilder: (BuildContext context, int index){
                      return RateUserWidget(user: state.users![index]);
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
      ),
    );
  }
}
