import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

class ButtonComponent extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final bool fullWidth;

  const ButtonComponent({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.color,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? context.color.primaryAccent,
        foregroundColor: context.color.inverseText,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppNumbers.radius)),
        padding: const EdgeInsets.symmetric(horizontal: AppNumbers.padding, vertical: AppNumbers.paddingSmall * 1.4),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon), const SizedBox(width: AppNumbers.space)],
          Text(
            title,
            style: TextStyle(
              fontSize: AppNumbers.getH3(context),
              fontWeight: FontWeight.w600,
              color: context.color.inverseText,
            ),
          ),
        ],
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
