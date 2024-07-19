import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.amber[800],
    unselectedItemColor: Colors.grey,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.amber[800],
    unselectedItemColor: Colors.grey,
  ),
);
