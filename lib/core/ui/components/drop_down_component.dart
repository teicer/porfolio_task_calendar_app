import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

class _DropdownDecor extends StatelessWidget {
  const _DropdownDecor({required this.child, this.hideBorder = false});

  final Widget child;
  final bool hideBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hideBorder
          ? null
          : BoxDecoration(color: context.color.overBg, borderRadius: BorderRadius.circular(AppNumbers.radius)),
      padding: const EdgeInsets.symmetric(horizontal: AppNumbers.padding, vertical: 2),
      child: DropdownButtonHideUnderline(child: child),
    );
  }
}

class DropDownComponent<T> extends StatelessWidget {
  const DropDownComponent({
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
    super.key,
    this.isExpanded = true,
    this.hideBorder = false,
    this.isEnabled = true,
    this.forceRowTitle = false,
    this.topPadding = true,
  });

  final String title;
  final List<T> items;
  final T? value;
  final ValueChanged<T> onChanged;
  final bool isExpanded;
  final bool hideBorder;
  final bool isEnabled;
  final bool forceRowTitle;
  final bool topPadding;
  final String Function(T)? labelBuilder;

  String _labelFor(T item) {
    if (labelBuilder != null) return labelBuilder!(item);
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Widget dropdownChild = _DropdownDecor(
      hideBorder: hideBorder,
      child: DropdownButton<T>(
        isExpanded: isExpanded,
        value: value,
        dropdownColor: context.color.overBg,
        borderRadius: BorderRadius.circular(AppNumbers.radius),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: context.color.secondaryText),
        hint: Text(
          '-',
          style: TextStyle(
            color: context.color.secondaryText.withValues(alpha: 0.7),
            fontSize: AppNumbers.body(context),
          ),
        ),
        onChanged: isEnabled
            ? (x) {
                if (x != null) onChanged(x);
              }
            : null,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              _labelFor(item),
              style: TextStyle(
                color: isEnabled ? context.color.primaryText : context.color.disabledText,
                fontSize: AppNumbers.body(context),
              ),
            ),
          );
        }).toList(),
      ),
    );

    if (forceRowTitle) {
      return Padding(
        padding: topPadding ? const EdgeInsets.only(top: AppNumbers.space) : EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title.isNotEmpty)
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: AppNumbers.body(context),
                    fontWeight: FontWeight.bold,
                    color: context.color.primaryText,
                  ),
                ),
              ),
            Expanded(child: dropdownChild),
          ],
        ),
      );
    }

    return Padding(
      padding: topPadding ? const EdgeInsets.only(top: AppNumbers.space) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: AppNumbers.space),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppNumbers.body(context),
                  fontWeight: FontWeight.bold,
                  color: context.color.primaryText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppNumbers.spaceSmall),
          ],
          dropdownChild,
        ],
      ),
    );
  }
}
