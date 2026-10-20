import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:porfolio_task_calendar_app/core/models/task_day_model.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';

class CalendarStripComponent extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback? onMonthTap;
  final List<TaskDayModel> taskDays;

  const CalendarStripComponent({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.onMonthTap,
    required this.taskDays,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<DateTime> _getCurrentWeekDays(DateTime referenceDate) {
    final startOfWeek = referenceDate.subtract(Duration(days: referenceDate.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String _weekdayInitial(BuildContext context, DateTime date) {
    final daysStr = context.loc.calendar_days_str.split(',');
    return daysStr[date.weekday - 1];
  }

  String _formatDateKey(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  TaskDayModel? _getDayModel(DateTime date) {
    final key = _formatDateKey(date);
    for (final model in taskDays) {
      if (model.dueDate == key) return model;
    }
    return null;
  }

  // Dots indicators widget
  Widget _buildIndicators(DateTime date, BuildContext context, {double size = AppNumbers.spaceSmall}) {
    final model = _getDayModel(date);
    if (model == null) {
      return SizedBox(height: size);
    }

    final hasOverdue = model.overdue > 0;
    final hasScheduled = model.scheduled > 0;

    if (!hasOverdue && !hasScheduled) {
      return SizedBox(height: size);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasOverdue)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: context.color.overdueDot, shape: BoxShape.circle),
          ),
        if (hasOverdue && hasScheduled) const SizedBox(width: 2),
        if (hasScheduled)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: context.color.scheduledDot, shape: BoxShape.circle),
          ),
      ],
    );
  }

  Future<void> _openDatePicker(BuildContext context) async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (dialogCtx) {
        DateTime focused = selectedDate;
        DateTime selected = selectedDate;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: context.color.bg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppNumbers.radius)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppNumbers.padding, vertical: AppNumbers.paddingSmall),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TableCalendar(
                      firstDay: DateTime(2020),
                      lastDay: DateTime(2035),
                      focusedDay: focused,
                      currentDay: DateTime.now(),
                      selectedDayPredicate: (day) => _isSameDay(day, selected),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: AppNumbers.getH3(context),
                          fontWeight: FontWeight.bold,
                          color: context.color.primaryText,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left, color: context.color.primaryText),
                        rightChevronIcon: Icon(Icons.chevron_right, color: context.color.primaryText),
                      ),
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: TextStyle(color: context.color.primaryText),
                        weekendTextStyle: TextStyle(color: context.color.secondaryText),
                        outsideDaysVisible: false,
                        selectedDecoration: BoxDecoration(color: context.color.primaryAccent, shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(
                          border: Border.all(color: context.color.primaryAccent, width: 1.5),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(color: context.color.primaryText),
                      ),
                      onDaySelected: (newSelected, newFocused) {
                        setModalState(() {
                          selected = newSelected;
                          focused = newFocused;
                        });
                      },
                      onPageChanged: (newFocused) {
                        focused = newFocused;
                      },

                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          return _buildIndicators(date, context, size: 5);
                        },
                      ),
                    ),
                    const SizedBox(height: AppNumbers.space),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          child: Text(context.loc.cancel, style: TextStyle(color: context.color.secondaryText)),
                        ),
                        const SizedBox(width: AppNumbers.spaceSmall),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: context.color.primaryAccent),
                          onPressed: () => Navigator.pop(dialogCtx, selected),
                          child: Text(context.loc.ok, style: TextStyle(color: context.color.inverseText)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekDays = _getCurrentWeekDays(selectedDate);
    final monthName = DateFormat('MMM').format(selectedDate);

    return SizedBox(
      height: 80,
      child: Row(
        children: [
          GestureDetector(
            onTap: onMonthTap ?? () => _openDatePicker(context),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(color: context.color.overBg, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: AppNumbers.body(context), color: context.color.primaryText),
                  const SizedBox(height: AppNumbers.spaceSmall),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        monthName,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.color.primaryText),
                      ),
                      Icon(Icons.arrow_drop_down, size: 14, color: context.color.primaryText),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppNumbers.space),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) {
                final isSelected = _isSameDay(day, selectedDate);
                final isToday = _isSameDay(day, now);

                return GestureDetector(
                  onTap: () => onDateSelected(day),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIndicators(day, context, size: AppNumbers.spaceSmall),
                      const SizedBox(height: AppNumbers.spaceSmall),
                      Container(
                        width: 38,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isSelected ? context.color.primaryAccent : context.color.overBg,
                          borderRadius: BorderRadius.circular(20),
                          border: (!isSelected && isToday)
                              ? Border.all(color: context.color.primaryAccent, width: 1.5)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weekdayInitial(context, day),
                              style: TextStyle(
                                fontSize: AppNumbers.body(context),
                                fontWeight: FontWeight.w600,
                                color: isSelected ? context.color.inverseText : context.color.primaryText,
                              ),
                            ),
                            const SizedBox(height: AppNumbers.spaceSmall),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: AppNumbers.body(context),
                                fontWeight: FontWeight.w600,
                                color: isSelected ? context.color.inverseText : context.color.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
