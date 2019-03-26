import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flow_list/pages/base/base_page.dart';
import 'package:flutter_flow_list/pages/settings/login_page.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:flutter_flow_list/util/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FirebasePoweredPage extends BasePage {
  FirebasePoweredPage();
}

abstract class FirebasePoweredPageState<T extends FirebasePoweredPage>
    extends BasePageState<T> {
  String userId;

  @override
  void initState() {
    super.initState();

    restoreSession();
  }

  Future<Null> restoreSession() async {
    await Preferences.load();

    userId = Preferences.getString(Preferences.KEY_USER_UID);
    if (userId != null) {
      setState(() {
        initFirebaseReferences(userId);
      });
    } else {
      openLoginPage();
    }
  }

  void initFirebaseReferences(String userId) {}

  Future<Null> logout() async {
    Preferences.setString(Preferences.KEY_USER_UID, null);
    userId = null;
    openLoginPage();
  }

  Future<Null> openLoginPage() async {
    final result = await Navigator.of(context).pushNamed(UIData.loginRoute);

    if (result) {
      restoreSession();
    } else {
      showEmpty();
//      Navigator.of(context).pop(false);
    }
  }
}
