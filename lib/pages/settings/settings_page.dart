import 'package:flutter/material.dart';
import 'package:flutter_flow_list/pages/base/base_page.dart';
import 'package:flutter_flow_list/ui/common_switch.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:flutter_flow_list/util/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends BasePage {
  @override
  State<StatefulWidget> createState() => new _SettingsPageState();
}

class _SettingsPageState extends BasePageState<SettingsPage> {
  bool darkTheme = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<Null> getData() async {
    await Preferences.load();
    darkTheme = Preferences.getBool(Preferences.KEY_SETTINGS_THEME);
    showContent();
  }

  @override
  String getPageTitle() {
    return "SETTINGS";
  }

  void _onAccountClicked() {
    Navigator.pushNamed(context, UIData.settingsLoginRoute);
  }

  void _onDarkThemeClicked(bool enabled) {
    Preferences.setBool(Preferences.KEY_SETTINGS_THEME, enabled);
    setState(() {
      darkTheme = enabled;
      print("Dark theme: $enabled");
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
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  title: Text("Account"),
                  subtitle: Text(Preferences.getString(Preferences.KEY_USER_UID, def: null) ??
                      "Click to log in!"),
                  onTap: _onAccountClicked,
                  trailing: Icon(Icons.arrow_right),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Visual",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.format_paint,
                    color: Colors.grey,
                  ),
                  title: Text("Dark theme"),
                  trailing: CommonSwitch(
                    onChanged: _onDarkThemeClicked,
                    defValue: darkTheme,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
