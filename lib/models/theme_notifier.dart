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
