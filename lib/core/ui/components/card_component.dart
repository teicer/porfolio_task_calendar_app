import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';

class CardComponent extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final double? radius;
  final double? padding;

  const CardComponent({super.key, required this.child, this.onTap, this.color, this.radius, this.padding});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? context.color.overBg,
        borderRadius: BorderRadius.circular(radius ?? AppNumbers.radius),
        boxShadow: context.color.cardShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius ?? AppNumbers.radius),
        onTap: onTap,
        child: Padding(padding: EdgeInsets.all(padding ?? AppNumbers.paddingSmall), child: child),
      ),
    );
  }
}
