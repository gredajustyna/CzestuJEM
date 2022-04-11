import 'dart:io';
import 'package:czestujem/presentation/blocs/user_data_bloc/user_data_bloc.dart';
import 'package:czestujem/presentation/blocs/user_data_bloc/user_data_event.dart';
import 'package:czestujem/presentation/blocs/user_data_bloc/user_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart' as path;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../../config/themes/colors.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  User user = FirebaseAuth.instance.currentUser!;
  String dropdownValue = '0.5 km';
  TextEditingController nameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  late Future<PickedFile?> pickedFile = Future.value(null);
  late File imageFile;
  late String fileName;
  bool hasNameChanged = false;

  @override
  void initState() {
    nameController.addListener(() {
      hasNameChanged = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
        'Ustawienia',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody(){
    return BlocListener<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if(state is UserDataDone){
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Zapisano dane!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: Duration(milliseconds: 750),
                backgroundColor: foodBlueGreen,
              ));
        }else if(state is UserDataLoading){
          context.loaderOverlay.show();
        }else if(state is UserDataError){
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Coś poszło nie tak! Spróbuj jeszcze raz!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: Duration(milliseconds: 750),
                backgroundColor: foodOrange,
              ));
        }
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 20.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<PickedFile?>(
                      future: pickedFile,
                      builder: (context, snap) {
                        if (snap.hasData) {
                          imageFile = File(snap.data!.path);
                          fileName = path.basename(snap.data!.path);
                          return CircleAvatar(
                            backgroundImage: FileImage(imageFile),
                            radius: 50,
                            backgroundColor: Colors.transparent,
                          );
                        }else if(user.photoURL != null){
                          return CircleAvatar(
                            backgroundImage: NetworkImage(user.photoURL!),
                            radius: 50,
                            backgroundColor: Colors.transparent,
                          );
                        }else{
                          return CircleAvatar(
                            child: user.photoURL != null ?
                            Image.network(user.photoURL!) :
                            Icon(LineIcons.userCircle,
                              size: 100,
                              color: foodBlueGreen,
                            ),
                            radius: 50,
                            backgroundColor: Colors.transparent,
                          );
                        }
                      },
                    ),
                    SizedBox(width: 2.w,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.grey[300],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0.3.h),
                        child: IconButton(
                          onPressed: (){
                            pickedFile =  _picker.getImage(source: ImageSource.gallery).whenComplete(() => {setState(() {})});
                          },
                          icon: Icon(Icons.add_a_photo_outlined,
                            color: foodGrey,
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ),
              Text(user.displayName!,
                style: TextStyle(
                  color: foodBlueGreen,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2
                ),
              ),
              Divider(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 90.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(LineIcons.envelope,
                          color: foodGrey,
                        ),
                        Text(user.email!,
                          style: TextStyle(
                            color: foodGrey
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 90.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(LineIcons.mapPin,
                              color: foodGrey,
                            ),
                            Text('Wybierz promień odbioru jedzenia:',
                              style: TextStyle(
                                  color: foodGrey
                              ),
                            )
                          ],
                        ),
                        DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(LineIcons.angleDown),
                          elevation: 16,
                          style: TextStyle(color: foodGrey, fontFamily: GoogleFonts.montserrat().fontFamily),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>['0.5 km', '1 km', '2 km', '5 km', '10 km']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 90.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(LineIcons.user,
                              color: foodGrey,
                            ),
                            Text('Zmień swoją nazwę: ',
                              style: TextStyle(
                                  color: foodGrey
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 2.h),
                          child: Container(
                            width: 80.w,
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
                                  prefixIcon: Icon(LineIcons.userCircle, size: 24),
                                  focusColor: foodBlueGreen,
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: foodGrey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: foodBlueGreen,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                controller: nameController..text = user.displayName!,
                                style: TextStyle(
                                  color: foodGrey,
                                ),
                                onFieldSubmitted: (String value){

                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.w, 3.w, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if(hasNameChanged){
                        Map<String, dynamic> data = {'fileName' : fileName, 'imageFile' : imageFile, 'username' : nameController.text};
                        BlocProvider.of<UserDataBloc>(context).add(UpdateUserData(data));
                      }else{
                        Map<String, dynamic> data = {'fileName' : fileName, 'imageFile' : imageFile};
                        BlocProvider.of<UserDataBloc>(context).add(UpdateUserData(data));
                      }
                    },
                    child: Text(
                      'Zapisz',
                      style: TextStyle(
                          color: foodBlueGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp
                      ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
