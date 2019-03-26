import 'package:flutter/material.dart';
import 'package:flutter_flow_list/pages/base/notfound_page.dart';
import 'package:flutter_flow_list/pages/chat/chat_page.dart';
import 'package:flutter_flow_list/pages/kopr/kopr_add_page.dart';
import 'package:flutter_flow_list/pages/kopr/kopr_list_page.dart';
import 'package:flutter_flow_list/pages/settings/login_page.dart';
import 'package:flutter_flow_list/pages/settings/settings_page.dart';
import 'package:flutter_flow_list/ui/fancy_bottom_navigation.dart';
import 'package:flutter_flow_list/util/uidata.dart';

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem, this.rootContext});

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final BuildContext rootContext;

  void _push(BuildContext context) {
    var routeBuilders = _routeBuilders(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[UIData.detailRoute](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
//      UIData.homeRoute: (context) => ColorsListPage(
//            color: TabHelper.color(tabItem, context),
//            title: TabHelper.description(tabItem),
//            onPush: (materialIndex) =>
//                _push(context, materialIndex: materialIndex),
//          ),
//      UIData.detailRoute: (context) => ColorDetailPage(
//            color: TabHelper.color(tabItem, context),
//            title: TabHelper.description(tabItem),
//            materialIndex: materialIndex,
//            rootContext: rootContext, //added
//          ),
//      UIData.homeRoute: (context) => NotFoundPage(),
      UIData.loginRoute: (context) => LoginPage(),
      UIData.chatRoute: (context) => ChatPage(),
      UIData.koprRoute: (context) => KoprListPage(),
      UIData.koprAddRoute: (context) => KoprAddNotePage(),
      UIData.settingsRoute: (context) => SettingsPage(),
      UIData.settingsLoginRoute: (context) => LoginPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      initialRoute: TabHelper.initialRoute(tabItem),
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
      onUnknownRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => NotFoundPage());
      },
    );
  }
}
