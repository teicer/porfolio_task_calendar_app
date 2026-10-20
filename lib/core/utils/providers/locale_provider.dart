import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/shared_prefs_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/translations_helper.dart';

class LocaleProvider with ChangeNotifier {
  static final LocaleProvider _instance = LocaleProvider._internal();
  factory LocaleProvider() {
    return _instance;
  }
  LocaleProvider._internal();
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await SharedPrefsProvider.setValue(AppConstants.locale, locale.languageCode);
    await TranslationsHelper().loadTranslations(locale.languageCode);
    notifyListeners();
  }

  Future<void> loadLocale() async {
    final String? savedLocale = await SharedPrefsProvider.getStringValue(AppConstants.locale);
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    } else {
      _locale = const Locale('en');

      await SharedPrefsProvider.setValue(AppConstants.locale, 'en');
    }
    notifyListeners();
  }
}
