import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/models/category_model.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/card_component.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/locale_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/theme_provider.dart';

class AppUI {
  static Row leftSideWidgetHome(BuildContext context, ThemeProvider themeProvider, LocaleProvider localeProvider) {
    return Row(
      children: [
        Row(
          children: [
            Material(
              color: context.color.cardBorder,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  if (themeProvider.themeMode == ThemeMode.dark) {
                    themeProvider.toggleTheme(AppThemeEnum.light);
                  } else {
                    themeProvider.toggleTheme(AppThemeEnum.dark);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppNumbers.paddingSmall),
                  child: Icon(themeProvider.themeMode == ThemeMode.dark ? Symbols.dark_mode : Symbols.light_mode),
                ),
              ),
            ),
            const SizedBox(width: AppNumbers.spaceSmall),
            //Lang
            Material(
              color: context.color.cardBorder,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  if (localeProvider.locale.languageCode == 'en') {
                    localeProvider.setLocale(const Locale('el'));
                  } else {
                    localeProvider.setLocale(const Locale('en'));
                  }
                },
                child: Padding(padding: const EdgeInsets.all(AppNumbers.paddingSmall), child: Icon(Symbols.language)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget deleteButton(BuildContext context, VoidCallback onTap) {
    return Material(
      color: context.color.cardBorder,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(AppNumbers.paddingSmall), child: Icon(Symbols.delete)),
      ),
    );
  }

  static Widget categoryCard(
    BuildContext context,
    List<CategoryModel> categories,
    TaskModel task, {
    bool expanded = false,
  }) {
    final category = categories.firstWhere((c) => c.id == task.categoryId, orElse: () => CategoryModel());
    if (category.name.isEmpty) return const SizedBox.shrink();
    if (expanded) {
      return CardComponent(
        color: AppUtils.getCategoryColor(context, category.nameAlias),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppNumbers.space),
          child: Text(
            AppUtils.getTranslation(category.nameAlias),
            style: TextStyle(fontSize: AppNumbers.body(context), color: context.color.white),
          ),
        ),
      );
    }

    return CardComponent(
      color: AppUtils.getCategoryColor(context, category.nameAlias),
      padding: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppNumbers.space, vertical: AppNumbers.spaceSmall),
        child: Text(
          AppUtils.getTranslation(category.nameAlias),

          style: TextStyle(color: context.color.white, fontSize: AppNumbers.caption(context)),
        ),
      ),
    );
  }

  static Widget statusCard(BuildContext context, TaskModel task) {
    if (task.completed) return const SizedBox.shrink();
    final today = DateTime.now().toIso8601String().split('T').first;
    final isOverdue = task.dueDate.isNotEmpty && task.dueDate.compareTo(today) < 0;
    final isDueToday = task.dueDate == today;
    final isScheduled = task.dueDate.isNotEmpty && task.dueDate.compareTo(today) > 0;

    return CardComponent(
      color: isOverdue
          ? context.color.overdueCardBg
          : isDueToday
          ? context.color.todayCardBg
          : isScheduled
          ? context.color.scheduledCardBg
          : context.color.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppNumbers.space),
        child: Text(
          isOverdue
              ? context.loc.overdue
              : isDueToday
              ? context.loc.today
              : isScheduled
              ? context.loc.scheduled
              : '',
          style: TextStyle(fontSize: AppNumbers.body(context), color: context.color.white),
        ),
      ),
    );
  }
}
