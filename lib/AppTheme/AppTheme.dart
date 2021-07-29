import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xff2A9D8F),
    accentColor: Color(0xffFFB800),
    brightness: Brightness.light,
    canvasColor: Colors.white,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue, //thereby
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Color(0xff2A9D8F),
      iconTheme: IconThemeData(
        color: Colors.black54,
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: -0.03,
                fontFamily: 'Montserrat'),
          ),
    ),
    cardTheme: CardTheme(
      shadowColor: Colors.black54,
      color: Colors.white.withOpacity(0.85),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.black54,
      onPrimary: Color(0xff696b9e),
      secondary: Color(0xfff29a94),
      primaryVariant: Colors.black54,
      background: Colors.grey[100],
      //used for text in notes
      onSurface: Colors.grey[700],
      onBackground: Colors.grey[600],
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.03,
            fontFamily: 'Montserrat',
          ),
          headline5: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.03,
            fontFamily: 'Montserrat',
          ),
          headline4: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.black,
          ),
          button: TextStyle(
            color: Color(0xff2A9D8F),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
          subtitle1: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 15,
          ),
          subtitle2: TextStyle(color: Colors.black, fontSize: 20),
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.black),
        ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xff2A9D8F),
    accentColor: Color(0xffFFB800),
    brightness: Brightness.dark,
    canvasColor: Colors.grey[800],
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue, //thereby
    ),
    scaffoldBackgroundColor: Colors.grey[850],
    appBarTheme: AppBarTheme(
      color: Colors.grey[900],
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: ThemeData.dark().textTheme.copyWith(
            headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: -0.03,
                fontFamily: 'Montserrat'),
          ),
    ),
    colorScheme: ColorScheme.dark(
      //used for profile screen dot color
      primary: Colors.white54,
      //used for color of notes list tile
      onPrimary: Colors.grey[300],
      secondary: Color(0xfff29a94),
      background: Colors.grey[800],
      onSurface: Colors.white60,
      onBackground: Colors.grey,
    ),
    cardTheme: CardTheme(
      shadowColor: Colors.white38,
      color: Colors.black.withOpacity(0.85),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    accentIconTheme: IconThemeData(color: Colors.grey[850]),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.03,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
          headline5: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.03,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
          headline4: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.03,
              fontFamily: 'Montserrat',
              color: Colors.white),
          button: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
          subtitle1: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Montserrat',
          ),
          subtitle2: TextStyle(color: Colors.white, fontSize: 20),
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
  );
}
