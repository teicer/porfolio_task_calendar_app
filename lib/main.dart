import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:porfolio_task_calendar_app/core/l10n/app_localizations.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/auth/auth_page.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/debug/debug_page.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/init_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/locale_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:porfolio_task_calendar_app/core/utils/translations_helper.dart';

import 'core/utils/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  final localeProvider = LocaleProvider();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  await Future.wait([themeProvider.loadTheme(), localeProvider.loadLocale()]);
  await SupabaseService.initialize();
  final localeCode = localeProvider.locale.languageCode;
  await TranslationsHelper().loadTranslations(localeCode);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeProvider(), LocaleProvider()]),
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: appKey,
          theme: ThemeData(
            brightness: ThemeProvider().themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
          ),
          themeMode: ThemeMode.system,
          locale: LocaleProvider().locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('el'), // Greek
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current locale is supported
            if (supportedLocales.any((supportedLocale) => supportedLocale.languageCode == locale?.languageCode)) {
              return locale;
            }
            // Fallback to English if the locale is not supported
            return const Locale('en');
          },

          home: SupabaseService.client.auth.currentUser == null ? AuthPage() : InitPage(),
        );
      },
    );
  }
}
