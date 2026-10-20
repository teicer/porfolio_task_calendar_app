import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsProvider {
  //Set a value of any type (dynamic)
  static Future<bool> setValue(String key, dynamic value) async {
    final p = await SharedPreferences.getInstance();
    if (value is String) return p.setString(key, value);
    if (value is int) return p.setInt(key, value);
    if (value is bool) return p.setBool(key, value);
    if (value is double) return p.setDouble(key, value);
    Log.e('Unsupported value type for key: $key');
    return false;
  }

  //Get a string value
  static Future<String?> getStringValue(String key) async {
    final p = await SharedPreferences.getInstance();
    final x = p.getString(key);
    return x;
  }

  //Get a boolean value
  static Future<bool?> getBoolValue(String key) async {
    final p = await SharedPreferences.getInstance();
    final x = p.getBool(key);
    return x;
  }

  //Get an integer value
  static Future<int?> getIntValue(String key) async {
    final p = await SharedPreferences.getInstance();
    final x = p.getInt(key);
    return x;
  }

  //Get a double value
  static Future<double?> getDoubleValue(String key) async {
    final p = await SharedPreferences.getInstance();
    final x = p.getDouble(key);
    return x;
  }

  //Clear a value by key
  static Future<bool> clearValue(String key) async {
    final p = await SharedPreferences.getInstance();
    return p.remove(key);
  }

  //Clear all values
  static Future<bool> clearAll() async {
    final p = await SharedPreferences.getInstance();
    return p.clear();
  }

  ///Debug: Print all key-value pairs in SharedPreferences
  static Future<void> debugPrintAll() async {
    final p = await SharedPreferences.getInstance();
    final keys = p.getKeys();
    for (var key in keys) {
      final value = p.get(key);
      Log.e('$key: $value');
    }
  }
}
