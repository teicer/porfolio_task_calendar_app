import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/button_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/input_component.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

class RegisterSection extends StatefulWidget {
  const RegisterSection({super.key});

  @override
  State<RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();
  final TextEditingController _cConfirmPassword = TextEditingController();
  @override
  void dispose() {
    _cEmail.dispose();
    _cPassword.dispose();
    _cConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            context.loc.register,
            style: TextStyle(
              fontSize: AppNumbers.getH1(context),
              fontWeight: FontWeight.bold,
              color: context.color.primaryText,
            ),
          ),
        ),
        const SizedBox(height: AppNumbers.space),
        Text(
          context.loc.register_message,
          style: TextStyle(fontSize: AppNumbers.body(context), color: context.color.primaryText),
        ),
        const SizedBox(height: AppNumbers.space),
        InputComponent(title: context.loc.email, controller: _cEmail, onCard: true, isEmail: true),
        InputComponent(title: context.loc.password, controller: _cPassword, onCard: true, isPassword: true),
        InputComponent(
          title: context.loc.confirm_password,
          controller: _cConfirmPassword,
          onCard: true,
          isPassword: true,
        ),
        const SizedBox(height: AppNumbers.space),

        ButtonComponent(
          title: context.loc.register,
          onPressed: () {
            // Handle registration action
          },
        ),
      ],
    );
  }
}
