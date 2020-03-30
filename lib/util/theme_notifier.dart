import 'package:flutter/material.dart';
import 'package:flutter_flow_list/util/constants.dart';

class ThemeNotifier with ChangeNotifier {
  AppTheme _themeData;

  ThemeNotifier(this._themeData);

  AppTheme get appTheme => _themeData;

  setTheme(AppTheme appTheme) async {
    _themeData = appTheme;
    notifyListeners();
  }
}

class ThemeHelper {
  static MaterialColor swatchLight = MaterialColor(0xff6200ee, {
    50: Color(0xffece0fd),
    100: Color(0xffd0b3fa),
    200: Color(0xffb180f7),
    300: Color(0xff914df3),
    400: Color(0xff7a26f1),
    500: Color(0xff6200ee),
    600: Color(0xff5a00ec),
    700: Color(0xff5000e9),
    800: Color(0xff4600e7),
    900: Color(0xff3400e2),
  });

  static MaterialColor swatchDark = MaterialColor(0xff808080, {
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
  });

  static ThemeData getThemeLight(BuildContext context) {
    return ThemeData(
      primarySwatch: swatchLight,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            buttonColor: swatchLight.shade500,
            minWidth: 100.0,
            colorScheme: Theme.of(context).buttonTheme.colorScheme.copyWith(primary: swatchLight.shade500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
            textTheme: ButtonTextTheme.primary,
          ),
    );
  }

  static ThemeData getThemeDark(BuildContext context) {
    return ThemeData(
      primarySwatch: swatchDark,
      accentColor: swatchDark.shade900,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            buttonColor: swatchLight.shade200,
            minWidth: 100.0,
            colorScheme: Theme.of(context).buttonTheme.colorScheme.copyWith(primary: swatchLight.shade200),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
            textTheme: ButtonTextTheme.primary,
          ),
      brightness: Brightness.dark,
    );
  }
}
