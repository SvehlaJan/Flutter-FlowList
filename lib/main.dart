import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/app.dart';
import 'package:flutter_flow_list/bloc/simple_bloc_delegate.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';

void main() async {
  await Preferences.load();
  int appThemeIndex = Preferences.getInt(Preferences.KEY_SETTINGS_THEME) ?? 0;
  AppTheme appTheme = AppTheme.values[appThemeIndex];

  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MainApp(appTheme));
}

class MainApp extends StatefulWidget {
  final AppTheme _defaultAppTheme;

  MainApp(this._defaultAppTheme);

  @override
  State<StatefulWidget> createState() => MainAppState(_defaultAppTheme);
}

class MainAppState extends State<MainApp> {
  AppTheme appTheme;
  
  MainAppState(this.appTheme);
  
  void setAppTheme(AppTheme newAppTheme) {
    setState(() {
      appTheme = newAppTheme;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    ThemeData themeData;
    if (appTheme == AppTheme.light) {
      themeData = ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        cardColor: Colors.white,
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      );
    } else {
      themeData = ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        cardColor: Colors.black87,
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      );
    }
    return MaterialApp(
      title: 'FlowList',
      theme: themeData,
      home: FlowApp(),
    );
  }
}
