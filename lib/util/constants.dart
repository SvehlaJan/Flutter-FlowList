import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum AppTheme { light, dark }

class Constants {
  static const String FIRESTORE_USERS = "users";
  static const String FIRESTORE_FLOW_NOTES = "flow_notes";
  
  static const String FIRESTORE_ID = "id";
  static const String FIRESTORE_PROVIDER_ID = "provider_id";
  static const String FIRESTORE_NICKNAME = "nickname";
  static const String FIRESTORE_EMAIL = "email";
  static const String FIRESTORE_PHOTO_URL = "photo_url";

  static const double uploadImageMaxSize = 1024;
  static const double avatarImageSize = 52;

  //routes
  static const String loginRoute = "login";
  static const String detailRoute = "/detail";
  static const String koprRoute = "kopr";
  static const String koprDetailRoute = "kopr/detail";
  static const String koprAddRoute = "kopr/add";
  static const String chatRoute = "chat";
  static const String settingsRoute = "settings";
  static const String settingsLoginRoute = "settings/login";
  static const String notFoundRoute = "not_found";

  //strings
  static const String appName = "Dz Playground";

  //fonts
  static const String quickFont = "Quicksand";
  static const String ralewayFont = "Raleway";
  static const String quickBoldFont = "Quicksand_Bold.otf";
  static const String quickNormalFont = "Quicksand_Book.otf";
  static const String quickLightFont = "Quicksand_Light.otf";

  //images
  static const String imageDir = "assets/images";
  static const String pkImage = "$imageDir/pk.jpg";
  static const String profileImage = "$imageDir/profile.jpg";
  static const String blankImage = "$imageDir/blank.jpg";
  static const String dashboardImage = "$imageDir/dashboard.jpg";
  static const String loginImage = "$imageDir/login.jpg";
  static const String paymentImage = "$imageDir/payment.jpg";
  static const String settingsImage = "$imageDir/setting.jpeg";
  static const String shoppingImage = "$imageDir/shopping.jpeg";
  static const String timelineImage = "$imageDir/timeline.jpeg";
  static const String verifyImage = "$imageDir/verification.jpg";

  //generic
  static const String str_error = "Error";
  static const String str_success = "Success";
  static const String str_ok = "OK";
  static const String str_forgot_password = "Forgot Password?";
  static const String str_something_went_wrong = "Something went wrong";
  static const String str_coming_soon = "Coming Soon";

  static const MaterialColor ui_kit_color = Colors.grey;

  static List<AppTheme> appThemes = [AppTheme.light, AppTheme.dark];

//colors
  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Colors.blueGrey.shade800,
    Colors.black87,
  ];
  static List<Color> kitGradients2 = [
    Color(0xffb7ac50),
    Colors.orange.shade900
  ];

  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}
