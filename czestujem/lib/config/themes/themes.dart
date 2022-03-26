import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class Themes{
  static ThemeData get light {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: foodBlueGreen,
      ),
      scaffoldBackgroundColor: Colors.grey[100],
      primaryColor: foodBlueGreen,
      splashColor: Colors.transparent,
      fontFamily: GoogleFonts.montserrat().fontFamily,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: foodBlueGreen)
    );
  }

  static ThemeData get dark {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.black12,
      dividerColor: Colors.black12,
      primaryColor: foodBlueGreen,
      splashColor: Colors.transparent,
      fontFamily: GoogleFonts.montserrat().fontFamily,
    );
  }
}