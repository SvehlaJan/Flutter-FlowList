import 'package:flutter/material.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  String getPageTitle() => null;

  FloatingActionButton getPageFab(BuildContext context) => null;

  void finishScreen() async {
    if (await onBackPressed() == true) {
      Navigator.pop(context, false);
    }
  }

  List<AppBarAction> getAppBarActions(BuildContext context) => null;

  /// Return true if stack should pop. False will block the back-press.
  Future<bool> onBackPressed() async => Future.value(true);

  Widget buildWillPopScope(BuildContext context, Widget body) => WillPopScope(onWillPop: onBackPressed, child: body);

  Widget buildScaffold(BuildContext context, Widget body, {Color backgroundColor, FloatingActionButton fab}) {
    bool showAppBar = getPageTitle() != null || getAppBarActions(context) != null;
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: backgroundColor != null ? backgroundColor : Theme.of(context).scaffoldBackgroundColor,
        appBar: showAppBar
            ? AppBar(
                leading: ModalRoute.of(context).canPop ? IconButton(icon: BackButtonIcon(), onPressed: finishScreen) : null,
                title: Text(getPageTitle()),
                actions: _buildAppBarActions(context),
              )
            : null,
        body: Builder(builder: (BuildContext context) => body),
        floatingActionButton: fab ?? getPageFab(context),
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    List<AppBarAction> actions = getAppBarActions(context);
    List<Widget> widgets = List();

    if (actions == null) {
      return widgets;
    } else if (actions.length <= 2) {
      widgets.addAll(actions.map((action) => _makeImageButton(action)));
    } else {
      widgets.add(_makeImageButton(actions[0]));
      widgets.add(_makePopupMenu(actions.skip(1)));
    }
    return widgets;
  }

  Widget _makeImageButton(AppBarAction action) => IconButton(icon: Icon(action.icon), onPressed: () => action.onTap());

  Widget _makePopupMenu(Iterable<AppBarAction> actions) {
    return PopupMenuButton<AppBarAction>(
      onSelected: (action) => action.onTap(),
      itemBuilder: (BuildContext context) => actions.map((AppBarAction action) {
        return PopupMenuItem<AppBarAction>(
            value: action,
            child: Row(children: <Widget>[
              Padding(padding: const EdgeInsets.only(right: 16.0), child: Icon(action.icon, color: Theme.of(context).accentColor)),
              Text(action.title),
            ]));
      }).toList(),
    );
  }
}

class AppBarAction {
  const AppBarAction(this.title, this.icon, this.onTap);

  final String title;
  final IconData icon;
  final Function onTap;
}
