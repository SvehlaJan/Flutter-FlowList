import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/theme_notifier.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/ui/common_switch.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends BasePageState<SettingsPage> {
  AppTheme _appTheme;

  @override
  void initState() {
    super.initState();

    int appThemeIndex = Preferences.getInt(Preferences.KEY_SETTINGS_THEME) ?? 0;
    _appTheme = AppTheme.values[appThemeIndex];
  }

  @override
  String getPageTitle() => "Settings";

  void _onThemeSwitchClicked(bool enabled) {
    AppTheme newTheme = enabled ? AppTheme.dark : AppTheme.light;
    Preferences.setInt(Preferences.KEY_SETTINGS_THEME, newTheme.index);

    Provider.of<ThemeNotifier>(context, listen: false).setTheme(newTheme);

    setState(() {
      _appTheme = newTheme;
    });
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Do you want to log out?"),
          actions: <Widget>[
            FlatButton(
              child: Text("LOG OUT", style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).accentColor)),
              onPressed: () {
                Provider.of<UserRepository>(context, listen: false).signOut();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return buildScaffold(
        context,
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("General Setting", style: Theme.of(context).textTheme.subtitle1),
              ),
              Card(
                child: Consumer<UserRepository>(
                  builder: (BuildContext context, UserRepository userRepository, Widget child) {
                    switch (userRepository.status) {
                      case Status.Uninitialized:
                      case Status.Unauthenticated:
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Account"),
                          subtitle: Text("Click to log in!"),
                          onTap: () => Navigator.pushNamed(context, Constants.settingsLoginRoute),
                          trailing: Icon(Icons.arrow_right),
                        );
                      case Status.Authenticating:
                        return Constants.centeredProgressIndicator;
                      case Status.Authenticated:
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Account"),
                          subtitle: Text(userRepository.currentUser.name),
                          onTap: () => showLogoutDialog(),
                        );
                    }
                    return Constants.centeredProgressIndicator;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Visual", style: Theme.of(context).textTheme.subtitle1),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.format_paint),
                      title: Text("Dark theme"),
                      trailing: CommonSwitch(
                        onChanged: _onThemeSwitchClicked,
                        defValue: (_appTheme == AppTheme.dark) ? true : false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
