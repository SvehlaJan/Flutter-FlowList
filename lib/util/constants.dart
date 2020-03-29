import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_flow_list/util/theme/theme_dark.dart';
import 'package:flutter_flow_list/util/theme/theme_light.dart';

enum AppTheme { light, dark }

extension AppThemeExtension on AppTheme {
  ThemeData get themeData => this == AppTheme.dark ? themeDark : themeLight;
}

class Constants {
  static const String GIPHY_API_KEY = "Nfewh7d1aZmroeV1E22KO8kofEbe4cvD";

  static const String FIRESTORE_USERS = "users";
  static const String FIRESTORE_FLOW_NOTES = "flow_notes";

  static const double uploadImageMaxSize = 1024;
  static const double avatarImageSize = 52.0;
  static const double chatBubbleHeight = 52.0;

  static const double favoriteIconSize = 20.0;
  static const double progressPlaceholderSize = 40.0;
  static const double successPlaceholderSize = 100.0;
  static const Widget progressIndicator = const SizedBox(width: Constants.progressPlaceholderSize, height: Constants.progressPlaceholderSize, child: CircularProgressIndicator());
  static const Widget centeredProgressIndicator = const Center(child: progressIndicator);
  static const Widget centeredSuccessIndicator = const Center(child: Icon(Icons.check, size: successPlaceholderSize));

  //routes
  static const String loginRoute = "login";
  static const String recordsListRoute = "kopr";
  static const String recordDetailRoute = "kopr/add";
  static const String chatRoute = "chat";
  static const String settingsRoute = "settings";
  static const String settingsLoginRoute = "settings/login";
  static const String notFoundRoute = "not_found";

  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}
