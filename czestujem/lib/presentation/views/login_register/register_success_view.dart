import 'package:czestujem/config/themes/colors.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

class RegisterSuccessView extends StatelessWidget {
  const RegisterSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DelayedDisplay(
              delay: Duration(milliseconds: 700),
              child: Text('Udało się!',
                style: TextStyle(
                  color: foodBlueGreen,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            const DelayedDisplay(
              delay: Duration(milliseconds: 1400),
              child: Icon(
                LineIcons.checkCircle,
                size: 100,
                color: foodBlueGreen,
              )
            ),
            SizedBox(height: 10.h,),
            DelayedDisplay(
                delay: Duration(milliseconds: 2100),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/main');
                  },
                  child: Text(
                    'Przenieś mnie do dobrego jedzenia!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                    backgroundColor: MaterialStateProperty.all(foodBlueGreen),
                    elevation: MaterialStateProperty.all<double>(0),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
