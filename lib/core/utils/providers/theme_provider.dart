import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/shared_prefs_provider.dart';

class ThemeProvider with ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._internal();
  factory ThemeProvider() {
    return _instance;
  }
  ThemeProvider._internal();
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme(AppThemeEnum appTheme) async {
    _themeMode = appTheme == AppThemeEnum.dark ? ThemeMode.dark : ThemeMode.light;
    SharedPrefsProvider.setValue(
      AppConstants.themeModeKey,
      appTheme == AppThemeEnum.dark ? AppThemeEnum.dark.name : AppThemeEnum.light.name,
    );
    notifyListeners();
  }

  Future<void> loadTheme() async {
    String? savedTheme = await SharedPrefsProvider.getStringValue(AppConstants.themeModeKey);
    if (savedTheme == AppThemeEnum.dark.name) {
      _themeMode = ThemeMode.dark;
      await SharedPrefsProvider.setValue(AppConstants.themeModeKey, AppThemeEnum.dark.name);
    } else {
      _themeMode = ThemeMode.light;
      await SharedPrefsProvider.setValue(AppConstants.themeModeKey, AppThemeEnum.light.name);
    }
    notifyListeners();
  }
}
