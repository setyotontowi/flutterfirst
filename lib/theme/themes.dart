import 'package:flutter/material.dart';

abstract class AppTheme {
  static ColorScheme lightScheme = ColorScheme.fromSeed(seedColor: Color(0xFF353DFC));

  static ThemeData light([ColorScheme? colorScheme]) {
    colorScheme ??= lightScheme;

    return ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    ).copyWith(
        appBarTheme:
            AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: Colors.transparent),
        cardTheme: CardTheme(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            )),
        textTheme: TextTheme(
            displayLarge: TextStyle(
          color: const Color.fromARGB(66, 30, 30, 30),
        )));
  }
}

abstract class AppColor {
  static const List<Color> accentColorOptions = [
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
    Colors.blueAccent,
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.yellowAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
  ];
}
