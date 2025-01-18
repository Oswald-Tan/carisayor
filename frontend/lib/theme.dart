import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      // scaffoldBackgroundColor: Colors.white,
      fontFamily: "Poppins",
      // appBarTheme: const AppBarTheme(
      //     color: Colors.white,
      //     elevation: 0,
      //     iconTheme: IconThemeData(color: Colors.black),
      //     titleTextStyle: TextStyle(color: Colors.black)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kTextColor),
        bodyMedium: TextStyle(color: kTextColor),
        bodySmall: TextStyle(color: kTextColor),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),

      //custom circular progress indicator color
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF74B11A),
      ),
    );
  }
}

// const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(28)),
//   borderSide: BorderSide(color: kTextColor),
//   gapPadding: 10,
// );
