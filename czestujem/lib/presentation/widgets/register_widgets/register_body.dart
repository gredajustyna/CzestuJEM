import 'package:czestujem/config/themes/colors.dart';
import 'package:czestujem/presentation/blocs/register_bloc/register_bloc.dart';
import 'package:czestujem/presentation/blocs/register_bloc/register_event.dart';
import 'package:czestujem/presentation/blocs/register_bloc/register_state.dart';
import 'package:czestujem/presentation/widgets/register_widgets/register_background.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController comfirmPasswordController = TextEditingController();
  bool isPasswordObscured = true;
  bool isConfirmObscured = true;
  String warningText = '';

  //TODO:Ekran ładowania rejestracji

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state){
        if(state is RegisterDone){
          context.loaderOverlay.hide();
          Navigator.pushNamed(context, '/registersuccess');
        }else if(state is RegisterErrorWeakPassword){
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hasło powinno mieć przynajmniej 6 znaków!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: Duration(milliseconds: 750),
                backgroundColor: foodOrange,
              ));
        }else if(state is RegisterErrorUserExists){
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Użytkownik o podanym adresie email już istnieje!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: Duration(milliseconds: 750),
                backgroundColor: foodOrange,
              ));
        }else if(state is RegisterLoading){
          context.loaderOverlay.show();
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
          child: RegisterBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: 90.w,
                  child: Text('Zarejestruj się',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: foodBlueGreen,
                      fontSize: 20.sp,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
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
                          labelText: "email",
                          prefixIcon: Icon(LineIcons.at, size: 24),
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
                        controller: emailController,
                        style: TextStyle(
                          color: foodGrey,
                        ),
                        onFieldSubmitted: (String value){

                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
                        decoration: InputDecoration(
                          floatingLabelStyle: TextStyle(
                            color: foodBlueGreen,
                          ),
                          labelText: "nazwa",
                          prefixIcon: Icon(LineIcons.user, size: 24),
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
                        controller: nameController,
                        style: TextStyle(
                          color: foodGrey,
                        ),
                        onFieldSubmitted: (String value){

                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
                        obscureText: isPasswordObscured,
                        decoration: InputDecoration(
                          floatingLabelStyle: TextStyle(
                            color: foodBlueGreen,
                          ),
                          suffixIcon: InkWell(
                            child: Icon(
                              isPasswordObscured ? LineIcons.eye :LineIcons.eyeSlash,
                            ),
                            onTap:  (){
                              setState(() {
                                isPasswordObscured = !isPasswordObscured;
                              });
                            },
                          ),
                          fillColor: foodLightBlue,
                          labelText: "hasło",
                          prefixIcon: Icon(LineIcons.lock, size: 24),
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
                        controller: passwordController,
                        style: TextStyle(
                          color: foodGrey,
                        ),
                        onFieldSubmitted: (String value){

                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
                        obscureText: isConfirmObscured,
                        decoration: InputDecoration(
                          floatingLabelStyle: TextStyle(
                            color: foodBlueGreen,
                          ),
                          suffixIcon: InkWell(
                            child: Icon(
                              isConfirmObscured ? LineIcons.eye :LineIcons.eyeSlash,
                            ),
                            onTap:  (){
                              setState(() {
                                isConfirmObscured = !isConfirmObscured;
                              });
                            },
                          ),
                          fillColor: foodLightBlue,
                          labelText: "potwierdź hasło",
                          prefixIcon: Icon(LineIcons.lock, size: 24),
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
                        controller: comfirmPasswordController,
                        style: TextStyle(
                          color: foodGrey,
                        ),
                        onFieldSubmitted: (String value){

                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Container(
                    width: 90.w,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if(nameController.text.length <20 && nameController.text.length>0){
                            if(EmailValidator.validate(emailController.text)){
                              if(passwordController.text == comfirmPasswordController.text){
                                Map<String, String> params = {'email':emailController.text, 'password' : passwordController.text, 'name': nameController.text};
                                BlocProvider.of<RegisterBloc>(context).add(Register(params));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Hasła muszą być takie same!',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 750),
                                      backgroundColor: foodOrange,
                                    ));
                              }
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Podaj poprawny adres email!',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 750),
                                    backgroundColor: foodOrange,
                                  ));
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Nazwa powinna mieć od 1 do 20 znaków!',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 750),
                                  backgroundColor: foodOrange,
                                ));
                          }
                        },
                        child: Text(
                          'Zarejestruj',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
