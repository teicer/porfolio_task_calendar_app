import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

class SubTaskItemComponent extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onTap;
  final bool isHomePage;

  const SubTaskItemComponent({
    super.key,
    required this.title,
    required this.isDone,
    required this.onTap,
    this.isHomePage = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconDimension = isHomePage ? AppNumbers.iconXs(context) : AppNumbers.iconSm(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppNumbers.spaceSmall),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppNumbers.spaceSmall),
        child: Row(
          children: [
            Container(
              width: iconDimension,
              height: iconDimension,
              decoration: BoxDecoration(
                color: isDone ? context.color.secondaryText : context.color.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isDone ? context.color.secondaryText : context.color.secondaryText.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: isDone
                  ? Icon(Icons.check_rounded, size: iconDimension * 0.75, color: context.color.inverseText)
                  : null,
            ),
            const SizedBox(width: AppNumbers.paddingSmall),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isHomePage ? AppNumbers.caption(context) : AppNumbers.body(context),
                  color: isDone ? context.color.secondaryText : context.color.primaryText,
                  decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: context.color.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
