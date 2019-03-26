import 'package:flutter/material.dart';
import 'package:flutter_flow_list/app.dart';
import 'package:flutter_flow_list/pages/base/notfound_page.dart';
import 'package:flutter_flow_list/util/uidata.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData themeData;
    return MaterialApp(
      title: 'FlowList',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        cardColor: Colors.grey,
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: App(),
//      routes: {
//        UIData.homeRoute: (BuildContext context) => App(),
//        "/inputPage": (BuildContext context) => InputPage(),
//      },
//      onUnknownRoute: (RouteSettings rs) =>
//          new MaterialPageRoute(builder: (context) => new NotFoundPage()),
    );
  }
}
