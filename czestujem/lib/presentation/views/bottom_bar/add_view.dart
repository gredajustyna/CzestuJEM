import 'dart:io';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_bloc.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_state.dart';
import 'package:czestujem/presentation/widgets/category_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_material_pickers/helpers/show_date_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart'; // for other locales
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/config/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import 'package:czestujem/core/utils/globals.dart' as globals;
import 'package:uuid/uuid.dart';

import '../../../data/datasources/fire_base.dart';
import '../../blocs/food_bloc/food_event.dart';

class AddView extends StatefulWidget {
  const AddView({Key? key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  bool isPhotoChosen = false;
  final ImagePicker _picker = ImagePicker();
  late Future<PickedFile?> pickedFile = Future.value(null);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int selectedCategory = 0;
  late File imageFile;
  bool isImageInitialized = false;
  late String fileName;
  var date = DateTime.now();

  @override
  void initState() {
    initializeDateFormatting('pl');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener <FoodBloc, FoodState>(
      listener: (context, state) {
        if(state is FoodDone){
          context.loaderOverlay.hide();
          showSnackBar('Pomyślnie dodano jedzenie!', foodBlueGreen);
          _titleController.clear();
          _dateController.clear();
          _descriptionController.clear();
          pickedFile = Future.value(null);
          isPhotoChosen = false;
        }else if(state is FoodLoading){
          context.loaderOverlay.show();
        }else if(state is FoodError){
          context.loaderOverlay.hide();
          showSnackBar('Coś poszło nie tak!', foodOrange);
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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 7.h,),
                Text("Dodaj ofertę",
                  style: TextStyle(
                    color: foodBlueGreen,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    width: 90.w,
                    child: Text("Krok 1: Wybierz zdjęcie",
                      style: TextStyle(
                          color: foodGrey,
                          fontSize: 15.sp
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<PickedFile?>(
                      future: pickedFile,
                      builder: (context, snap) {
                        if (snap.hasData) {
                          imageFile = File(snap.data!.path);
                          fileName = path.basename(snap.data!.path);
                          isImageInitialized = true;
                          return Container(
                            width: 35.w,
                            height: 35.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: foodGrey,
                                  width: 2
                                )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                File(snap.data!.path),
                                fit: BoxFit.cover
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: 35.w,
                          height: 35.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: foodGrey,
                                  width: 2
                              )
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10.w,),
                    InkWell(
                      onTap: () async{
                        pickedFile =  _picker.getImage(source: ImageSource.gallery).whenComplete(() => {setState(() {})});
                      },
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        child: Icon(
                          LineIcons.plus,
                          color: foodGrey,
                          size: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    width: 90.w,
                    child: Text("Krok 2: Dodaj nazwę jedzenia",
                      style: TextStyle(
                          color: foodGrey,
                          fontSize: 15.sp
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 90.w,
                  child: TextFormField(
                    //EDIT TEXT CONTROLLER
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(
                        color: foodBlueGreen,
                      ),
                      labelText: "np. ser żółty plastry",
                      fillColor: foodLightBlue,
                      prefixIcon: Icon(LineIcons.utensils, size: 24),
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
                    controller: _titleController,
                    style: TextStyle(
                      color: foodGrey,
                    ),
                    onFieldSubmitted: (String value){

                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    width: 90.w,
                    child: Text("Krok 3: Wybierz kategorię",
                      style: TextStyle(
                          color: foodGrey,
                          fontSize: 15.sp
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 90.w,
                  height: 6.h,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      fillColor: foodBlueGreen,
                      selectedColor: Colors.white,
                      color: foodGrey,
                      borderRadius: BorderRadius.circular(20),
                      borderWidth: 2,
                      borderColor: foodGrey,
                      selectedBorderColor: foodGrey,
                      isSelected: globals.selectedCategories,
                      children: globals.categories.map((e) => CategoryWidget(category: e)).toList(),
                      onPressed: (int index) {
                        setState(() {
                          for (int indexBtn = 0;indexBtn < globals.selectedCategories.length;indexBtn++) {
                            if (indexBtn == index) {
                              globals.selectedCategories[indexBtn] = true;
                              selectedCategory = indexBtn;
                            } else {
                              globals.selectedCategories[indexBtn] = false;
                            }
                          }
                        });
                      }
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    width: 90.w,
                    child: Text("Krok 4: Wybierz datę ważności",
                      style: TextStyle(
                          color: foodGrey,
                          fontSize: 15.sp
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 90.w,
                  child: TextFormField(
                    //EDIT TEXT CONTROLLER
                    readOnly: true,
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(
                        color: foodBlueGreen,
                      ),
                      fillColor: foodLightBlue,
                      prefixIcon: Icon(LineIcons.calendar, size: 24),
                      suffixIcon: InkWell(
                        onTap: (){
                          _showDatePicker();
                        },
                        child: Icon(
                          LineIcons.search
                        ),
                      ),
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
                    controller: _dateController..text = DateFormat.yMMMMd().format(date).toString(),
                    style: TextStyle(
                      color: foodGrey,
                    ),
                    onFieldSubmitted: (String value){

                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    width: 90.w,
                    child: Text("Krok 5: Dodaj opis jedzenia",
                      style: TextStyle(
                          color: foodGrey,
                          fontSize: 15.sp
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 90.w,
                  child: TextFormField(
                    //EDIT TEXT CONTROLLER
                    maxLines: 7,
                    decoration: InputDecoration(
                      label: Text('np. wyjeżdżam, oddam zawartość lodówki',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: foodGrey
                        ),
                      ),
                      floatingLabelStyle: TextStyle(
                        color: foodBlueGreen,
                      ),
                      alignLabelWithHint: true,
                      fillColor: foodLightBlue,
                      //prefixIcon: Icon(LineIcons.hamburger, size: 24),
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
                    controller: _descriptionController,
                    style: TextStyle(
                      color: foodGrey,
                    ),
                    onFieldSubmitted: (String value){

                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      width: 90.w,
                      child: Text("... i gotowe!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: foodGrey,
                            fontSize: 15.sp
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_titleController.text.isNotEmpty){
                        if(_descriptionController.text.isNotEmpty){
                          var uuid = Uuid();
                          if(isImageInitialized){
                            Food food = Food('1', _titleController.text,
                                _descriptionController.text,
                                GeoPoint(globals.location.latitude, globals.location.longitude),
                                globals.categories[globals.selectedCategories.indexOf(true)],
                                date, FirebaseAuth.instance.currentUser!.uid, uuid.v1(), 'dostępne');
                            Map<String, dynamic> foodToAdd = {
                              'foodFileName' : fileName,
                              'foodImageFile' : imageFile,
                              'food' : food
                            };
                            BlocProvider.of<FoodBloc>(context).add(AddFood(foodToAdd));
                          }else{
                            Food food = Food('', _titleController.text,
                                _descriptionController.text,
                                GeoPoint(globals.location.latitude, globals.location.longitude),
                                globals.categories[globals.selectedCategories.indexOf(true)],
                                date, FirebaseAuth.instance.currentUser!.uid, uuid.v1(), 'dostępne');
                            Map<String, dynamic> foodToAdd = {
                              'foodFileName' : '',
                              'foodImageFile' : File(''),
                              'food' : food
                            };
                            BlocProvider.of<FoodBloc>(context).add(AddFood(foodToAdd));
                          }
                        }else{
                          showSnackBar('Dodaj opis do jedzenia!', foodOrange);
                        }
                      }else{
                        showSnackBar('Nadaj nazwę swojej potrawie!', foodOrange);
                      }
                    },
                    child: Text(
                      'Dodaj!',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker(){
    showMaterialDatePicker(
      title: 'Data ważności:',
      buttonTextColor: foodGrey,
      cancelText: 'Anuluj',
      confirmText: 'Wybierz',
      context: context,
      selectedDate: date,
      onChanged: (value) => setState(() => date = value), firstDate: DateTime.now(), lastDate: DateTime(2030),
    );
  }

  void showSnackBar(String message, Color backgroundColor){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 750),
          backgroundColor: backgroundColor,
        ));
  }

}
