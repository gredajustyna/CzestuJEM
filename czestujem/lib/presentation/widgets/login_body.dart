import 'package:czestujem/config/themes/colors.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_event.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_state.dart';
import 'package:czestujem/presentation/blocs/reset_password_bloc/reset_password_bloc.dart';
import 'package:czestujem/presentation/blocs/reset_password_bloc/reset_password_event.dart';
import 'package:czestujem/presentation/blocs/reset_password_bloc/reset_password_state.dart';
import 'package:czestujem/presentation/widgets/login_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetEmailController = TextEditingController();
  bool isPasswordObscured = true;


  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state){
        if(state is LoginDone){
          context.loaderOverlay.hide();
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        }else if(state is LoginLoading){
          context.loaderOverlay.show();
        }else if(state is LoginErrorWrongPassword){
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błędne hasło!',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              duration: Duration(milliseconds: 750),
              backgroundColor: foodOrange,
            ));
        }else if(state is LoginErrorUserNotFound){
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Użytkownik o podanym adresie nie istnieje!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: Duration(milliseconds: 750),
                backgroundColor: foodOrange,
              ));
        }else if(state is LoginErrorTooManyRequests){
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Zbyt wiele razy wpisano błędne hasło! Odczekaj chwilę!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: Duration(milliseconds: 750),
                backgroundColor: foodOrange,
              ));
        }
      },
      child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state){
          if(state is ResetPasswordError){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Spróbuj ponownie!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: Duration(milliseconds: 750),
                backgroundColor: foodOrange,
              ));
          }else if(state is ResetPasswordDone){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Na podany adres wysłano email!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  duration: Duration(milliseconds: 750),
                  backgroundColor: foodBlueGreen,
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
            child: LoginBackground(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: 90.w,
                  child: Text('Zaloguj się',
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
                Container(
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
                        labelText: "hasło",
                        fillColor: foodLightBlue,
                        prefixIcon: Icon(LineIcons.lock, size: 24),
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
                      obscureText: isPasswordObscured,
                      style: TextStyle(
                        color: foodGrey,
                      ),
                      onFieldSubmitted: (String value){

                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    _showMyDialog();
                  },
                  child: Text(
                    "Nie pamiętam hasła",
                    style: TextStyle(
                      color: foodBlueGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    width: 90.w,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                            Map<String, String> params = {'email':emailController.text, 'password' : passwordController.text};
                            BlocProvider.of<LoginBloc>(context).add(LogIn(params));
                          }
                        },
                        child: Text(
                          'Zaloguj',
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
                Text(
                  "Nie masz konta?",
                  style: TextStyle(
                    color: foodBlueGreen
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    "Dołącz do nas już dziś!",
                    style: TextStyle(
                      color: foodBlueGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
          ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Aby zresetować hasło, podaj swój adres email:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foodBlueGreen,
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
                        controller: resetEmailController,
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
            )
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('Wyślij',
                    style: TextStyle(
                      color: foodBlueGreen
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    BlocProvider.of<ResetPasswordBloc>(context).add(ResetPassword(resetEmailController.text));
                    resetEmailController.clear();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}
