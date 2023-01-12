import 'package:flutter/material.dart';

const fontFamily = 'ReemKufi';

final themeLight = ThemeData(
  primaryColorLight: const Color(0xff509B61),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff509B61),
      titleTextStyle: TextStyle(color: Colors.white, fontFamily: fontFamily)),
  brightness: Brightness.light,
  primaryColor: const Color(0xff509B61),
  fontFamily: fontFamily,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
    secondary: Colors.black,
    brightness: Brightness.light,
  ),
);

final themeDark = ThemeData(
  brightness: Brightness.dark,
  primaryColorDark: const Color(0xff2C4833),
  fontFamily: fontFamily,
  appBarTheme: const AppBarTheme(
      backgroundColor: const Color(0xff2C4833),
      titleTextStyle: TextStyle(color: Colors.white, fontFamily: fontFamily)),
  primaryColor: const Color(0xff2C4833),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
    secondary: const Color(0xff2C4833),
    brightness: Brightness.dark,
  ),
);
