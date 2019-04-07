import 'package:flutter/material.dart';
import 'package:flutter_flow_list/main.dart';
import 'package:flutter_flow_list/pages/base/stateful_page.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/ui/common_switch.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';

class SettingsPage extends StatefulPage {
  @override
  State<StatefulWidget> createState() => new _SettingsPageState();
}

class _SettingsPageState extends StatefulPageState<SettingsPage> {
  AppTheme _appTheme;
  UserRepository _userRepository = UserRepository.get();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<Null> getData() async {
    await Preferences.load();
    int appThemeIndex = Preferences.getInt(Preferences.KEY_SETTINGS_THEME) ?? 0;
    _appTheme = AppTheme.values[appThemeIndex];
    showContent();
  }

  @override
  String getPageTitle() {
    return "Settings";
  }

  void _onAccountClicked() async {
    showProgress();

    bool signedIn = await _userRepository.isSignedInAsync();
    if (signedIn) {
      await _userRepository.signOut();
    } else {
      await _userRepository.signIn();
    }

    showContent();
  }

  void _onDarkThemeClicked(bool enabled) {
    AppTheme newAppTheme = enabled ? AppTheme.dark : AppTheme.light;
    Preferences.setInt(Preferences.KEY_SETTINGS_THEME, newAppTheme.index);
    MainAppState mainAppState =
        context.ancestorStateOfType(const TypeMatcher<MainAppState>());
    mainAppState.setAppTheme(newAppTheme);

    setState(() {
      _appTheme = newAppTheme;
      print("App theme: $newAppTheme");
    });
  }

  @override
  Widget getContentView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "General Setting",
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              title: Text("Account"),
              subtitle: Text(Preferences.getString(
                      Preferences.KEY_USER_NICK_NAME,
                      def: null) ??
                  "Click to log in!"),
              onTap: _onAccountClicked,
              trailing: Icon(Icons.arrow_right),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Visual",
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.format_paint,
                color: Colors.grey,
              ),
              title: Text("Dark theme"),
              trailing: CommonSwitch(
                onChanged: _onDarkThemeClicked,
                defValue: _appTheme.index != 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
