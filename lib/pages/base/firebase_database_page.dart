import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flow_list/pages/base/stateful_page.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';

abstract class FirebasePoweredPage extends StatefulPage {
  FirebasePoweredPage() : super();
}

abstract class FirebasePoweredPageState<T extends FirebasePoweredPage>
    extends StatefulPageState<T> {
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
    final result = await Navigator.of(context).pushNamed(Constants.loginRoute);

    if (result) {
      restoreSession();
    } else {
      showEmpty();
//      Navigator.of(context).pop(false);
    }
  }
}
