import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    canvasColor: Colors.white,
    primaryColor: Colors.teal,
    accentColor: Colors.amber,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey.shade300,
    appBarTheme: AppBarTheme(
      color: Colors.teal,
      iconTheme: IconThemeData(
        color: Colors.black54,
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
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
        background: Colors.white60,
        //used for text in notes
        onSurface: Colors.grey[700],
        onBackground: Colors.grey[600],
        ),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline5: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 18, color: Colors.black),
          headline4: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white),
          bodyText1: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.black),
          headline6: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          subtitle1: TextStyle(color: Colors.black, fontSize: 20),
          subtitle2: TextStyle(color: Colors.black, fontSize: 20),
          bodyText2: TextStyle(color: Colors.black),
        ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    canvasColor: Colors.grey[850],
    primaryColor: Colors.teal,
    accentColor: Colors.amber,
    scaffoldBackgroundColor: Colors.grey[850],
    appBarTheme: AppBarTheme(
      color: Colors.grey[900],
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: ThemeData.dark().textTheme.copyWith(
            headline6: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
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
          subtitle1: TextStyle(color: Colors.white, fontSize: 20),
          subtitle2: TextStyle(color: Colors.white, fontSize: 20),
          headline5: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
          headline4: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white),
          button: TextStyle(color: Colors.white),
          bodyText1: TextStyle(color: Colors.white),
          headline6: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          bodyText2: TextStyle(color: Colors.white),
        ),
  );
}
