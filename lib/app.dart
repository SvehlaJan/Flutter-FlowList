import 'package:flutter/material.dart';
import 'package:flutter_flow_list/navigation/tab_navigator.dart';
import 'package:flutter_flow_list/ui/fancy_bottom_navigation.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  static TabItem currentTab = TabItem.chat;
  /*
    changed currentTab to static to show the last shown navigator
    if it is not static it shows always the red Navigator if you pop from inputPage and not the last opened one
  */
  static Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    /*
      changed navigatorKeys to static to prevent generating new keys on every reuse of the App widget
      if new keys will generated new navigators will be used and because of this the state of each tab will be deleted
    */
    TabItem.list: GlobalKey<NavigatorState>(),
    TabItem.chat: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.list),
          _buildOffstageNavigator(TabItem.chat),
          _buildOffstageNavigator(TabItem.settings),
        ]),
        bottomNavigationBar: FancyBottomNavigation(
          currentTab,
          onTabChanged: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem,
        rootContext: context,
        /*
          this context is the context to the root navigator of MaterialApp
          the context is passed to each navigator and then to each page to give every page access to the root navigator
         */
      ),
    );
  }
}
