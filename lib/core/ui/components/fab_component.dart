import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

class FabComponent extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final bool isBig;
  final Color? color;

  const FabComponent({
    super.key,
    required this.onPressed,
    this.icon = Icons.edit_outlined,
    this.isBig = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double size = isBig ? 56.0 : 44.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? context.color.primaryAccent,
        shape: BoxShape.circle,
        boxShadow: context.color.cardShadow,
      ),
      child: Material(
        color: context.color.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: context.color.inverseText,
              size: isBig ? AppNumbers.body(context) * 1.5 : AppNumbers.body(context) * 1.25,
            ),
          ),
        ),
      ),
    );
  }
}
