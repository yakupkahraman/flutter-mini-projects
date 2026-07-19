import 'package:flutter/material.dart';

//dark theme

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.green,
  scaffoldBackgroundColor: Colors.black,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green[800],
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    surfaceTintColor: Colors.black,
  ),
);
