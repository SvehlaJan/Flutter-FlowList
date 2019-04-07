import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  BasePage() : super();
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  BuildContext scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getPageTitle()),
        actions: getPageActions(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          scaffoldContext = context;
          return buildBody();
        },
      ),
      floatingActionButton: getPageFab(),
    );
  }

  String getPageTitle() {
    return "No page title";
  }

  FloatingActionButton getPageFab() {
    return null;
  }

  List<Widget> getPageActions() {
    return null;
  }

  Widget buildBody();
}
