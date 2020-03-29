import 'package:flutter/material.dart';
import 'package:flutter_flow_list/app.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/util/language_notifier.dart';
import 'package:flutter_flow_list/util/theme_notifier.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/navigation/navigation_service.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:flutter_flow_list/util/app_localization_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  getIt.allReady().then((value) {
    int appThemeIndex = Preferences.getInt(Preferences.KEY_SETTINGS_THEME) ?? 0;
    AppTheme appTheme = AppTheme.values[appThemeIndex];
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier(appTheme)),
          ChangeNotifierProvider<AppLanguageNotifier>(create: (_) => AppLanguageNotifier()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final appLanguageNotifier = Provider.of<AppLanguageNotifier>(context);

//    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
//    bool isDark = brightnessValue == Brightness.dark;

    return MaterialApp(
      title: 'FlowList',
      navigatorKey: getIt<NavigationService>().navigationKey,
      theme: themeNotifier.appTheme.themeData,
      home: FlowApp(),
      locale: appLanguageNotifier.appLocal,
      localizationsDelegates: [
        AppLocalizationsService.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('sk'),
      ],
    );
  }
}
