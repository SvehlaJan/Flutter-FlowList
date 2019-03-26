import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  BasePage();

//  @override
//  BasePageState createState() => new BasePageState();
}

enum BaseState { progress, empty, content }

abstract class BasePageState<T extends BasePage> extends State<T> {
  BaseState currentState;
  BuildContext scaffoldContext;

  @override
  void initState() {
    super.initState();

    currentState = BaseState.progress;
  }

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

  Widget buildBody() {
    switch (currentState) {
      case BaseState.progress:
        return getProgressView();
      case BaseState.empty:
        return getEmptyView();
      case BaseState.content:
        return getContentView();
      default:
        return Container(child: Center(child: Text("No state...")));
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  void showProgress({bool force = false}) {
    _setBaseState(force, BaseState.progress);
  }

  void showEmpty({bool force = false}) {
    _setBaseState(force, BaseState.empty);
  }

  void showContent({bool force = false}) {
    _setBaseState(force, BaseState.content);
  }

  void _setBaseState(bool force, BaseState newState) {
    if (newState != currentState || force) {
      setState(() {
        currentState = newState;
      });
    }
  }

  Widget getProgressView() {
    return Material(
        color: Colors.white, child: Center(child: CircularProgressIndicator()));
  }

  Widget getEmptyView() {
    return Material(
        color: Colors.white, child: Center(child: Text("No data...")));
  }

  Widget getContentView() {
    return Material(
        color: Colors.white,
        child: Center(child: Text("No content... override!")));
  }
}
