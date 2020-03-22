import 'package:flutter/material.dart';
import 'package:flutter_flow_list/util/constants.dart';

enum TabItem { list, chat, settings }

class TabHelper {
  static List<BottomNavigationBarItem> getItems(BuildContext context) {
    List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[];
    for (TabItem tabItem in TabItem.values) {
      items.add(BottomNavigationBarItem(
          icon: Icon(getIcon(tabItem)),
          title: Text(
            getDescription(tabItem),
            style: Theme.of(context).textTheme.bodyText1,
          )));
    }
    return items;
  }

  static TabItem item({int index}) {
    switch (index) {
      case 0:
        return TabItem.list;
      case 1:
        return TabItem.chat;
      case 2:
        return TabItem.settings;
    }
    return TabItem.chat;
  }

  static String getDescription(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.list:
        return 'LIST';
      case TabItem.chat:
        return 'CHAT';
      case TabItem.settings:
        return 'SETTINGS';
    }
    return '';
  }

  static String getInitialRoute(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.list:
        return Constants.recordsListRoute;
      case TabItem.chat:
        return Constants.chatRoute;
      case TabItem.settings:
        return Constants.settingsRoute;
    }
    return Constants.notFoundRoute;
  }

  static IconData getIcon(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.list:
        return Icons.format_list_bulleted;
      case TabItem.chat:
        return Icons.chat;
      case TabItem.settings:
        return Icons.settings;
    }
    return Icons.error;
  }

  static MaterialColor getColor(TabItem tabItem, BuildContext context) {
    switch (tabItem) {
      case TabItem.list:
        return Theme.of(context).accentColor;
      case TabItem.chat:
        return Theme.of(context).accentColor;
      case TabItem.settings:
        return Theme.of(context).accentColor;
    }
    return Colors.grey;
  }
}
