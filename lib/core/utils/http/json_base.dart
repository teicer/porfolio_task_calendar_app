

import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';

class JsonBase {
  // create constructor with dynamic argument
  // and assign it to the private variable
  const JsonBase(this._jsonValue);
  final dynamic _jsonValue;
  static const int _defaultInt = -1;
  static const double _defaultDouble = -1.0;
  static const bool _defaultBool = false;
  static const String _defaultStr = "";

  String getStr(String key, {String defaultValue = _defaultStr}) {
    if (!_jsonValue.containsKey(key) || _jsonValue[key] == null) {
      if (!_jsonValue.containsKey(key)) {
        Log.e('Key not found: $key');
      }
      return defaultValue;
    }
    return _jsonValue[key] as String;
  }

  int getInt(String key, {int defaultValue = _defaultInt}) {
    if (!_jsonValue.containsKey(key) || _jsonValue[key] == null) {
      if (!_jsonValue.containsKey(key)) {
        Log.e('Key not found: $key');
      }
      return defaultValue;
    }
    return _jsonValue[key] as int;
  }

  double getDouble(String key, {double defaultValue = _defaultDouble}) {
    if (!_jsonValue.containsKey(key) || _jsonValue[key] == null) {
      if (!_jsonValue.containsKey(key)) {
        Log.e('Key not found: $key');
      }
      return defaultValue;
    }
    final double x = (_jsonValue[key] as num).toDouble();
    //trim to 3 digits
    return double.parse(x.toStringAsFixed(3));
  }

  double? getDoubleNullable(String key) {
    if (!_jsonValue.containsKey(key) || _jsonValue[key] == null) {
      if (!_jsonValue.containsKey(key)) {
        Log.e('Key not found: $key');
      }
      return null;
    }
    final double x = (_jsonValue[key] as num).toDouble();
    //trim to 3 digits
    return double.parse(x.toStringAsFixed(3));
  }

  bool getBool(String key, {bool defaultValue = _defaultBool}) {
    if (!_jsonValue.containsKey(key) || _jsonValue[key] == null) {
      if (!_jsonValue.containsKey(key)) {
        Log.e('Key not found: $key');
      }
      return defaultValue;
    }
    return _jsonValue[key] as bool;
  }

  // nested ones
  String getNestedStr(List<String> keys, {String defaultValue = _defaultStr}) {
    dynamic value = _jsonValue;
    for (final key in keys) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        if (value == null) {
          Log.e('Value ${keys.toString()} seems null');
          return defaultValue;
        }
        if (!value.containsKey(key)) {
          Log.e('Key not found: $key');
        }
        return defaultValue;
      }
    }
    if (value == null) return defaultValue;
    return value as String;
  }

  int getNestedInt(List<String> keys, {int defaultValue = _defaultInt}) {
    dynamic value = _jsonValue;
    for (final key in keys) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        if (value == null) {
          Log.e('Value ${keys.toString()} seems null');
          return defaultValue;
        }
        if (!value.containsKey(key)) {
          Log.e('Key not found: $key');
        }
        return defaultValue;
      }
    }
    if (value == null) return defaultValue;
    if (value is int) {
      return value;
    }
    try {
      return int.parse(value.toString());
    } catch (e) {
      return -1;
    }
  }

  double getNestedDouble(List<String> keys, {double defaultValue = _defaultDouble}) {
    dynamic value = _jsonValue;
    for (final key in keys) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        if (value == null) {
          Log.e('Value ${keys.toString()} seems null');
          return defaultValue;
        }
        if (!value.containsKey(key)) {
          Log.e('Key not found: $key');
        }
        return defaultValue;
      }
    }
    if (value == null) return defaultValue;
    if (value is num) {
      //trim to 3 digits
      return double.parse(value.toStringAsFixed(3));
    }
    try {
      return double.parse(value.toStringAsFixed(3));
    } catch (e) {
      return defaultValue;
    }
  }

  double? getNestedDoubleNullable(List<String> keys) {
    dynamic value = _jsonValue;
    for (final key in keys) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        if (value == null) {
          Log.e('Value ${keys.toString()} seems null');
          return null;
        }
        if (!value.containsKey(key)) {
          Log.e('Key not found: $key');
        }
        return null;
      }
    }
    if (value == null) return null;
    if (value is num) {
      return value.toDouble();
    }
    try {
      return double.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  bool getNestedBool(List<String> keys, {bool defaultValue = _defaultBool}) {
    dynamic value = _jsonValue;
    for (final key in keys) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        if (value == null) {
          Log.e('Value ${keys.toString()} seems null');
          return defaultValue;
        }
        if (!value.containsKey(key)) {
          Log.e('Key not found: $key');
        }
        return defaultValue;
      }
    }
    if (value == null) return defaultValue;
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return defaultValue;
  }

  // latlng

  double getCoord(List<String> keys, int cell) {
    dynamic value = _jsonValue;
    for (final key in keys) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        if (!value.containsKey(key)) {
          Log.e('Key not found: $key');
        }
        return _defaultDouble;
      }
    }
    if (value == null) return _defaultDouble;
    if (value is List) {
      return value[cell];
    }
    return _defaultDouble;
  }
}
