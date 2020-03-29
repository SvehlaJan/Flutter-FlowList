import 'package:flutter/material.dart';
import 'package:flutter_flow_list/pages/chat/flow_chat_page.dart';
import 'package:flutter_flow_list/pages/notes/detail/record_detail_page.dart';
import 'package:flutter_flow_list/pages/notes/list/records_list_page.dart';
import 'package:flutter_flow_list/pages/settings/login_page.dart';
import 'package:flutter_flow_list/pages/settings/settings_page.dart';
import 'package:flutter_flow_list/util/constants.dart';

class TabItem {
  final String name;
  final IconData icon;

  TabItem(this.name, this.icon);

  factory TabItem.records() => TabItem(Constants.recordsListRoute, Icons.format_list_bulleted);

  factory TabItem.chat() => TabItem(Constants.chatRoute, Icons.chat);

  factory TabItem.settings() => TabItem(Constants.settingsRoute, Icons.settings);

  static List<TabItem> getItems() => [TabItem.records(), TabItem.chat(), TabItem.settings()];

  static List<BottomNavigationBarItem> getBottomNavigationBarItem(BuildContext context) {
    List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[];
    for (TabItem tabItem in getItems()) {
      items.add(BottomNavigationBarItem(
          icon: Icon(tabItem.icon),
          title: Text(
            tabItem.name,
            style: Theme.of(context).textTheme.bodyText1,
          )));
    }
    return items;
  }
}

Widget generatePage(String name, {Object arguments}) {
  switch (name) {
    case Constants.loginRoute:
      return LoginPage();
    case Constants.chatRoute:
      return FlowChatPage();
    case Constants.recordsListRoute:
      return RecordsListPage();
    case Constants.recordDetailRoute:
      String dateStr = (arguments as Map ?? const {})[RecordDetailPage.ARG_DATE_STR];
      String photoUrl = (arguments as Map ?? const {})[RecordDetailPage.ARG_IMAGE_URL];
      return RecordDetailPage(dateStr, photoUrl);
    case Constants.settingsRoute:
      return SettingsPage();
    case Constants.settingsLoginRoute:
      return LoginPage();
  }

  return null;
}

Route<dynamic> generateRouteFromSettings(RouteSettings settings) {
  return _getPageRoute(routeName: settings.name, viewToShow: generatePage(settings.name, arguments: settings.arguments));
}

Route<dynamic> generateRoute(String name, {Object arguments}) {
  return _getPageRoute(routeName: name, viewToShow: generatePage(name, arguments: arguments));
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(settings: RouteSettings(name: routeName), builder: (_) => viewToShow);
}
