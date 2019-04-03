import 'package:flutter/material.dart';
import 'package:flutter_flow_list/pages/base/base_page.dart';

abstract class StatefulPage extends BasePage {
  StatefulPage() : super();
}

enum StatefulState { progress, empty, content }

abstract class StatefulPageState<T extends StatefulPage> extends BasePageState<T> {
  StatefulState currentState;

  @override
  void initState() {
    super.initState();

    currentState = StatefulState.progress;
  }

  Widget buildBody() {
    switch (currentState) {
      case StatefulState.progress:
        return getProgressView();
      case StatefulState.empty:
        return getEmptyView();
      case StatefulState.content:
        return getContentView();
      default:
        return Container(child: Center(child: Text("No state...")));
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  void showProgress({bool force = false}) {
    _setState(force, StatefulState.progress);
  }

  void showEmpty({bool force = false}) {
    _setState(force, StatefulState.empty);
  }

  void showContent({bool force = false}) {
    _setState(force, StatefulState.content);
  }

  void _setState(bool force, StatefulState newState) {
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
