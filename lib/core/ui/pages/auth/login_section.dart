import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/button_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/input_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/progress_dialog.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/debug/debug_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/auth_provider.dart';

class LoginSection extends StatefulWidget {
  const LoginSection({super.key});

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();

  @override
  void dispose() {
    _cEmail.dispose();
    _cPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //email: 'c.ioannou.94@gmail.com', password: 'Test123456!')
      _cEmail.text = 'c.ioannou.94@gmail.com';
      _cPassword.text = 'Test123456!';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            context.loc.login,
            style: TextStyle(
              fontSize: AppNumbers.getH1(context),
              fontWeight: FontWeight.bold,
              color: context.color.primaryText,
            ),
          ),
        ),
        const SizedBox(height: AppNumbers.space),
        Text(
          context.loc.login_message,
          style: TextStyle(fontSize: AppNumbers.body(context), color: context.color.primaryText),
        ),
        const SizedBox(height: AppNumbers.space),
        InputComponent(title: context.loc.email, controller: _cEmail, onCard: true, isEmail: true),
        InputComponent(title: context.loc.password, controller: _cPassword, onCard: true, isPassword: true),
        const SizedBox(height: AppNumbers.space),

        ButtonComponent(
          title: context.loc.login,
          onPressed: () async {
            if (_cEmail.text.isEmpty || _cPassword.text.isEmpty) {
              if (context.mounted) {
                context.snackbar(context.loc.please_fill_all_fields, type: PopupType.error);
              }
              return;
            }

            ProgressDialog.show();
            final res = await AuthProvider().signInWithPassword(_cEmail.text, _cPassword.text);
            ProgressDialog.dismiss();
            if (res.isSuccessful()) {
              if (context.mounted) {
                context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.success);
                await context.goTo(DebugPage());
              }
            } else {
              if (context.mounted) {
                context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.error);
              }
            }
          },
        ),
      ],
    );
  }
}
