import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flow_list/app.dart';
import 'package:flutter_flow_list/bloc/main_bloc.dart';
import 'package:flutter_flow_list/bloc/simple_bloc_delegate.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';

void main() async {
  print("main.dart: main start");
  BlocSupervisor.delegate = SimpleBlocDelegate();
  print("main.dart: main 1");
  await Preferences.load();
  print("main.dart: main 2");
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp();

  @override
  State<StatefulWidget> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  AppTheme _appTheme;

  MainAppState();

  @override
  void initState() {
    super.initState();
    print("MainAppState: initState");

    int appThemeIndex = Preferences.getInt(Preferences.KEY_SETTINGS_THEME) ?? 0;
    _appTheme = AppTheme.values[appThemeIndex];
  }

  void setAppTheme(AppTheme newAppTheme) {
    setState(() {
      _appTheme = newAppTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("MainAppState: build: Using theme: $_appTheme");

    ThemeData themeData;
    if (_appTheme == AppTheme.light) {
      themeData = ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
        primaryColorLight: Colors.red.shade100,
        accentColor: Colors.indigo,
        cardColor: Colors.white,
        textTheme: TextTheme(
//          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
      );
    } else {
      themeData = ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        primaryColorLight: Colors.red,
        accentColor: Colors.indigo,
        cardColor: Colors.black87,
        textTheme: TextTheme(
//          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
      );
    }
    return BlocProvider(
      builder: (context) => MainBloc(),
        child: MaterialApp(
      title: 'FlowList',
      theme: themeData,
      home: FlowApp(),
    ));
  }
}
