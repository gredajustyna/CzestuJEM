import 'package:czestujem/domain/entities/fireuser.dart';
import 'package:czestujem/presentation/blocs/rate_user_bloc/rate_user_bloc.dart';
import 'package:czestujem/presentation/blocs/rate_user_bloc/rate_user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../config/themes/colors.dart';

class RateUserWidget extends StatefulWidget {
  final FireUser user;
  const RateUserWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<RateUserWidget> createState() => _RateUserWidgetState();
}

class _RateUserWidgetState extends State<RateUserWidget> {
  late FireUser user;
  double rating = 0;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child:  user.photoURL != "" ?
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL),
                  radius: 30,
                  backgroundColor: Colors.transparent,
                ) :
                CircleAvatar(
                  child: Icon(LineIcons.userCircle,
                    size: 60,
                    color: foodBlueGreen,
                  ),
                  radius: 30,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Text(user.name,
                style: TextStyle(
                    color: foodBlueGreen,
                    fontSize: 15.sp
                ),
              ),
              IconButton(
                onPressed: (){
                  _showDeleteDialog();
                },
                icon:Icon(LineIcons.times, color: foodGrey,)
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFacesRow()
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    if(rating>0){
                      Map<String, dynamic> params = {'user' : user, 'mark': rating};
                      BlocProvider.of<RateUserBloc>(context).add(RateUser(params));
                    }
                    //_showMyDialog();
                    // var user = await FireBase.getUserFromUid(food.uid).then((value) {
                    //   Map<String, dynamic> message = {'user' : value, 'message' : Message('Witaj, jestem zainteresowana/y porcją: ${food.name}. Kiedy możemy się spotkać?', DateTime.now(), FirebaseAuth.instance.currentUser!.uid, false)};
                    //   BlocProvider.of<MessagesBloc>(context).add(SendMessage(message));
                    // });
                  },
                  child: Row(
                    children: [
                      Icon(LineIcons.check,
                        color: foodBlueGreen,
                      ),
                      Text(
                        'Oceń',
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
          )
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Czy jesteś pewien, że nie chcesz ocenić użytkownika: ${user.name}?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foodBlueGreen,
                    ),
                  ),
                  Text("Oceniając użytkowników pomagasz budować zaufanie między członkami jedzeniowej społeczności!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foodBlueGreen,
                    ),
                  ),
                ],
              )
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('Usuwam!',
                    style: TextStyle(
                        color: foodBlueGreen
                    ),
                  ),
                  onPressed: () async{
                    BlocProvider.of<RateUserBloc>(context).add(DeleteRate(user));
                    Navigator.of(context).pop();
                  },
                ),
                //),
                TextButton(
                  child: const Text('Anuluj',
                    style: TextStyle(
                        color: foodOrange
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  Widget _buildFacesRow(){
    if(rating >=4.5){
      return Row(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                rating = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: foodBlueGreen,
              ),
              child: Icon(LineIcons.cryingFace,
                size: 50,
              ),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 2;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color:  foodLightBlue,
              ),
              child: Icon(LineIcons.frowningFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 3;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color:  Colors.yellow,
              ),
              child: Icon(LineIcons.neutralFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 4;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color:  foodLightOrange,
              ),
              child: Icon(LineIcons.smilingFace,size: 50,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodOrange,
            ),
            child: Icon(LineIcons.grinningFace,size: 50,),
          ),
        ],
      );
    }else if(rating <4.5 && rating >=3.5){
      return Row(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                rating = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: foodBlueGreen,
              ),
              child: Icon(LineIcons.cryingFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 2;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color:  foodLightBlue,
              ),
              child: Icon(LineIcons.frowningFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 3;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color:  Colors.yellow,
              ),
              child: Icon(LineIcons.neutralFace,size: 50,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodLightOrange,
            ),
            child: Icon(LineIcons.smilingFace,size: 50,),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 5;
              });
            },
            child: Container(
              child: Icon(LineIcons.grinningFace,size: 50,),
            ),
          ),
        ],
      );
    } else if(rating <3.5 && rating >=2.5){
      return Row(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                rating = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: foodBlueGreen,
              ),
              child: Icon(LineIcons.cryingFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 2;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color:  foodLightBlue,
              ),
              child: Icon(LineIcons.frowningFace,size: 50,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  Colors.yellow,
            ),
            child: Icon(LineIcons.neutralFace,size: 50,),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 4;
              });
            },
            child: Container(
              child: Icon(LineIcons.smilingFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 5;
              });
            },
            child: Container(
              child: Icon(LineIcons.grinningFace,size: 50,),
            ),
          ),
        ],
      );
    }else if(rating <2.5 && rating >=1.5){
      return Row(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                rating = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: foodBlueGreen,
              ),
              child: Icon(LineIcons.cryingFace,size: 50,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color:  foodLightBlue,
            ),
            child: Icon(LineIcons.frowningFace,size: 50,),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 3;
              });
            },
            child: Container(
              child: Icon(LineIcons.neutralFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 4;
              });
            },
            child: Container(
              child: Icon(LineIcons.smilingFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 5;
              });
            },
            child: Container(
              child: Icon(LineIcons.grinningFace,size: 50,),
            ),
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
            child: Icon(LineIcons.cryingFace,size: 50,),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 2;
              });
            },
            child: Container(
              child: Icon(LineIcons.frowningFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 3;
              });
            },
            child: Container(
              child: Icon(LineIcons.neutralFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 4;
              });
            },
            child: Container(
              child: Icon(LineIcons.smilingFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 5;
              });
            },
            child: Container(
              child: Icon(LineIcons.grinningFace,size: 50,),
            ),
          ),
        ],
      );
    }else{
      return Row(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                rating = 1;
              });
            },
            child: Container(
              child: Icon(LineIcons.cryingFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 2;
              });
            },
            child: Container(
              child: Icon(LineIcons.frowningFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 3;
              });
            },
            child: Container(
              child: Icon(LineIcons.neutralFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 4;
              });
            },
            child: Container(
              child: Icon(LineIcons.smilingFace,size: 50,),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                rating = 5;
              });
            },
            child: Container(
              child: Icon(LineIcons.grinningFace,size: 50,),
            ),
          ),
        ],
      );
    }
  }
}
