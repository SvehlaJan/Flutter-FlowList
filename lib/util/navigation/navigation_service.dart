import 'package:flutter/material.dart';
import 'package:flutter_flow_list/util/navigation/navigation_helper.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.push(generateRoute(routeName, arguments: arguments));
  }
}
