import 'package:material_ui/material_ui.dart';

enum AppThemeEnum { light, dark }

enum PopupType { success, error, info }

class AppConstants {
  static const String themeModeKey = 'themeMode';
  static const String locale = 'locale';
  static const String cardUp = 'cardUp';
  static const String datePattern = 'datePattern';
  static const int defaultPageSize = 10;

  static const String tasks = 'tasks';
  static const String categories = 'categories';
  static const String account = 'account';

  static const languages = [
    {'name': 'English', 'locale': Locale('en'), 'flag': 'lib/core/images/ic_flag_en.png', 'lang_code': 'en'},
    {'name': 'Ελληνικά', 'locale': Locale('el'), 'flag': 'lib/core/images/ic_flag_el.png', 'lang_code': 'el'},
  ];
}
