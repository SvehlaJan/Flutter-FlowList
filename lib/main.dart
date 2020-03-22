import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flow_list/app.dart';
import 'package:flutter_flow_list/bloc/main_bloc.dart';
import 'package:flutter_flow_list/bloc/simple_bloc_delegate.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/theme_notifier.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  return Preferences.initAndGet().then((prefs) {
    int appThemeIndex = Preferences.getInt(Preferences.KEY_SETTINGS_THEME) ?? 0;
    AppTheme appTheme = AppTheme.values[appThemeIndex];
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier(appTheme)),
          ChangeNotifierProvider<UserRepository>(create: (_) => getIt<UserRepository>()),
          ChangeNotifierProvider<FlowRepository>(create: (_) => getIt<FlowRepository>()),
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
    return BlocProvider(
        create: (context) => MainBloc(),
        child: MaterialApp(
          title: 'FlowList',
          theme: themeNotifier.appTheme.themeData,
          home: FlowApp(),
        ));
  }
}
