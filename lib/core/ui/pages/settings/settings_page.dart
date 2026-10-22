import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/button_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/drop_down_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/page_base.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/auth/auth_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/auth_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/date_time_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/locale_provider.dart';

import 'package:porfolio_task_calendar_app/core/utils/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  LocaleProvider localeProvider = LocaleProvider();
  ThemeProvider themeProvider = ThemeProvider();
  static const List<String> _dropdownFormats = ['dd/MM/yyyy', 'yyyy-MM-dd'];
  String _selectedDateFormat = _dropdownFormats[0];
  final DateTime _date = DateTime(2026, 1, 29);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedDateFormat = DateFormatProvider().currentFormat.pattern;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.e('___ _selectedDateFormat: $_selectedDateFormat');
    final Locale currentLocale = Localizations.localeOf(context);

    final filterLang = AppConstants.languages.firstWhere((lang) => lang['locale'] == currentLocale);
    return PageBase.normal(
      title: context.loc.settings,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropDownComponent(
                    title: context.loc.language_selection,
                    items: AppConstants.languages,
                    value: filterLang,
                    onChanged: (lang) {
                      if (localeProvider.locale.languageCode == 'en') {
                        localeProvider.setLocale(const Locale('el'));
                      } else {
                        localeProvider.setLocale(const Locale('en'));
                      }
                    },
                    labelBuilder: (lang) => lang['name'] as String,
                  ),
                  const SizedBox(height: AppNumbers.space),
                  DropDownComponent<DateFormatE>(
                    title: context.loc.date_format_selection,
                    items: DateFormatE.values,
                    value: DateFormatProvider().currentFormat,
                    onChanged: (format) async {
                      await DateFormatProvider().setFormat(format);
                      setState(() {
                        _selectedDateFormat = format.pattern;
                      });
                    },
                    labelBuilder: (format) => DateFormatProvider().format(_date, overrideFormat: format),
                  ),

                  const SizedBox(height: AppNumbers.space),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: AppNumbers.space),
                        child: Text(
                          context.loc.theme_selection,
                          style: TextStyle(
                            fontSize: AppNumbers.body(context),
                            fontWeight: FontWeight.bold,
                            color: context.color.primaryText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: AppNumbers.spaceSmall),
                        child: Transform.scale(
                          scale: 1.15,
                          child: Switch(
                            value: themeProvider.themeMode == ThemeMode.dark,
                            thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                              if (states.contains(WidgetState.selected)) {
                                return Icon(Icons.dark_mode_rounded, size: AppNumbers.iconSm(context));
                              }
                              return Icon(Icons.light_mode_rounded, size: AppNumbers.iconSm(context));
                            }),
                            onChanged: (value) {
                              if (themeProvider.themeMode == ThemeMode.dark) {
                                themeProvider.toggleTheme(AppThemeEnum.light);
                              } else {
                                themeProvider.toggleTheme(AppThemeEnum.dark);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ButtonComponent(
            title: context.loc.logout,
            color: context.color.error,
            onPressed: () async {
              final confirm = await context.dialogYesNo(
                context.loc.info,
                context.loc.are_you_sure_to_logout,
                Icons.logout,
              );
              if (confirm != true) return;

              final response = await AuthProvider().signOutResponse();
              if (response.isSuccessful()) {
                if (context.mounted) {
                  context.snackbar(context.loc.logout_successful, type: PopupType.success);
                  await context.goTo(AuthPage());
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
