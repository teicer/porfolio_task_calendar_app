import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';

class TranslationsHelper {
  factory TranslationsHelper() => _instance;
  TranslationsHelper._internal();
  static final TranslationsHelper _instance = TranslationsHelper._internal();

  // Internal cache of translations
  Map<String, String> _translations = {};

  // Load or reload translations from the ARB file for a given locale.
  Future<void> loadTranslations(String locale) async {
    final String filePath = 'lib/core/l10n/app_$locale.arb';
    try {
      final String fileContent = await rootBundle.loadString(filePath);
      final Map<String, dynamic> jsonContent = json.decode(fileContent);
      // Convert all values to strings and update the internal cache.
      _translations = jsonContent.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      Log.e("Error loading translations: $e");
      _translations = {};
    }
  }

  // Synchronously get a translation by key.
  String? getTranslation(String key) {
    key = key.toLowerCase();
    return _translations[key];
  }
}
