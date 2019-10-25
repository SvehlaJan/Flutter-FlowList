import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flow_list/navigation/tab_helper.dart';
import 'package:flutter_flow_list/pages/base/notfound_page.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_bloc.dart';
import 'package:flutter_flow_list/pages/chat/flow_chat_page.dart';
import 'package:flutter_flow_list/pages/flow/flow_note_detail.dart';
import 'package:flutter_flow_list/pages/flow/flow_notes_list.dart';
import 'package:flutter_flow_list/pages/settings/login_page.dart';
import 'package:flutter_flow_list/pages/settings/settings_page.dart';
import 'package:flutter_flow_list/util/constants.dart';

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem, this.rootContext});

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final BuildContext rootContext;

  Route<dynamic> _getRoute(RouteSettings settings) {
    Map<String, String> arguments;
    if (settings.arguments is Map<String, Object>) {
      arguments = settings.arguments;
    }

    switch (settings.name) {
      case Constants.loginRoute:
        return MaterialPageRoute<void>(
            settings: settings, builder: (BuildContext context) => LoginPage());
      case Constants.chatRoute:
        return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) => BlocProvider(
                builder: (context) => FlowChatBloc(), child: FlowChatPage()));
      case Constants.koprRoute:
        return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) => FlowNotesListPage());
      case Constants.koprAddRoute:
        String date;
        if (arguments != null &&
            arguments.containsKey(FlowNoteDetailPage.ARG_DATE)) {
          date = arguments[FlowNoteDetailPage.ARG_DATE];
        }
        return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) =>
                FlowNoteDetailPage(initDateString: date));
      case Constants.settingsRoute:
        return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) => SettingsPage());
      case Constants.settingsLoginRoute:
        return MaterialPageRoute<void>(
            settings: settings, builder: (BuildContext context) => LoginPage());
    }

    // The other paths we support are in the routes table.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: TabHelper.getInitialRoute(tabItem),
      onGenerateRoute: _getRoute,
      onUnknownRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => NotFoundPage());
      },
    );
  }
}
