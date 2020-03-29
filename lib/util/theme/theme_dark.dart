import 'package:flutter/material.dart';

/*
 * https://github.com/rxlabz/panache
 */

class ColorPalette {
  static const Color primary = Color(0xFF9E9E9E);
  static const Color primary_dark = Color(0xFF616161);
  static const Color primary_light = Color(0xFFF5F5F5);
  static const Color accent = Color(0xFFFF5722);
  static const Color primary_text = Color(0xFF212121);
  static const Color secondary_text = Color(0xFF757575);
  static const Color icons = Color(0xFF212121);
  static const Color divider = Color(0xFFBDBDBD);
}

Color colorPrimary = Color(0xFF9E9E9E);

final ThemeData themeDark = ThemeData(
  primarySwatch: MaterialColor(4280361249, {
    50: Color(0xfff2f2f2),
    100: Color(0xffe6e6e6),
    200: Color(0xffcccccc),
    300: Color(0xffb3b3b3),
    400: Color(0xff999999),
    500: Color(0xff808080),
    600: Color(0xff666666),
    700: Color(0xff4d4d4d),
    800: Color(0xff333333),
    900: Color(0xff191919)
  }),
  brightness: Brightness.dark,
);
