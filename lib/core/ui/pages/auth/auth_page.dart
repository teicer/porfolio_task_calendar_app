import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/app/app_ui.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/card_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/page_base.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/auth/login_section.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/auth/registrer_section.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/theme_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/locale_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  // final ThemeProvider themeProvider;
  // final LocaleProvider localeProvider;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _loginSection = true;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: PageBase.auth(
        title: '',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [AppUI.leftSideWidgetHome(context, ThemeProvider(), LocaleProvider())],
            ),
            const SizedBox(height: AppNumbers.space),
            CardComponent(
              child: Column(
                children: [
                  const SizedBox(width: double.infinity),
                  if (_loginSection) ...[LoginSection()] else ...[const RegisterSection()],
                  const SizedBox(height: AppNumbers.space),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _loginSection = !_loginSection;
                      });
                    },
                    child: Text(
                      _loginSection ? context.loc.already_have_account : context.loc.dont_have_account,
                      style: TextStyle(fontSize: AppNumbers.caption(context), color: context.color.secondaryText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
