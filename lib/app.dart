import 'package:flutter/material.dart';
import 'package:flutter_flow_list/util/R.dart';
import 'package:flutter_flow_list/util/navigation_helper.dart';

class FlowApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FlowAppState();
}

class FlowAppState extends State<FlowApp> {
  static int currentTabIndex = 1;

  void _selectTabIndex(int tabIndex) {
    setState(() {
      currentTabIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: generatePage(TabItem.getItems()[currentTabIndex].name),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryIconTheme.color,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        items: TabItem.getBottomNavigationBarItem(context),
        currentIndex: currentTabIndex,
        onTap: (tabIndex) => _selectTabIndex(tabIndex),
      ),
    );
  }
}
