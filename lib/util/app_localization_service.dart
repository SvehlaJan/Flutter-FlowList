import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_flow_list/locator.dart';

AppLocalizationsService strings = getIt<AppLocalizationsService>();

String localize(String key) => strings.translate(key);

class AppLocalizationsService {
  static const LocalizationsDelegate<AppLocalizationsService> delegate = _AppLocalizationsServiceDelegate();

  Map<String, String> _localizedStrings;

  Future<AppLocalizationsService> load(Locale locale) async {
    String jsonString = await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return this;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsServiceDelegate extends LocalizationsDelegate<AppLocalizationsService> {
  const _AppLocalizationsServiceDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'sk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizationsService> load(Locale locale) async {
    return await strings.load(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsServiceDelegate old) => false;
}
