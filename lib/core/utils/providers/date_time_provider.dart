import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/shared_prefs_provider.dart';

//yyyyMMddDash = yyyy-MM-dd
//ddMMyyyySlash = dd/MM/yyyy
enum DateFormatE { yyyyMMddDash, ddMMyyyySlash }

extension DateFormatEExtension on DateFormatE {
  String get pattern {
    switch (this) {
      case DateFormatE.ddMMyyyySlash:
        return 'dd/MM/yyyy';
      case DateFormatE.yyyyMMddDash:
        return 'yyyy-MM-dd';
    }
  }

  static DateFormatE fromPattern(String? pattern) {
    return DateFormatE.values.firstWhere((e) => e.pattern == pattern, orElse: () => DateFormatE.yyyyMMddDash);
  }
}

class DateFormatProvider extends ChangeNotifier {
  // Singleton instance
  static final DateFormatProvider _instance = DateFormatProvider._internal();
  factory DateFormatProvider() => _instance;
  DateFormatProvider._internal();

  DateFormatE _currentFormat = DateFormatE.yyyyMMddDash;

  DateFormatE get currentFormat => _currentFormat;
  String get currentPattern => _currentFormat.pattern;

  // Load the saved date format from SharedPreferences
  Future<void> init() async {
    final saved = await SharedPrefsProvider.getStringValue(AppConstants.datePattern);
    _currentFormat = DateFormatEExtension.fromPattern(saved);
    notifyListeners();
  }

  // Set a new date format, update the UI, and save it to SharedPreferences
  Future<void> setFormat(DateFormatE format) async {
    if (_currentFormat == format) return;
    _currentFormat = format;
    notifyListeners();
    await SharedPrefsProvider.setValue(AppConstants.datePattern, format.pattern);
  }

  // Formatting helpers
  String format(DateTime date, {DateFormatE? overrideFormat}) {
    final f = overrideFormat ?? _currentFormat;
    return DateFormat(f.pattern).format(date);
  }

  // Convert any date to yyyy-MM-dd for the API/DB
  String toApi(String dateStr) {
    final clean = dateStr.trim();
    if (clean.isEmpty) return clean;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(clean)) return clean;

    try {
      final parsed = DateFormat(DateFormatE.ddMMyyyySlash.pattern).parseStrict(clean);
      return DateFormat(DateFormatE.yyyyMMddDash.pattern).format(parsed);
    } catch (_) {
      try {
        final parsed = DateTime.parse(clean);
        return DateFormat(DateFormatE.yyyyMMddDash.pattern).format(parsed);
      } catch (_) {
        return clean;
      }
    }
  }
}
