import 'package:material_ui/material_ui.dart';
import 'package:porfolio_task_calendar_app/core/models/task_day_model.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/singleton_data_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/translations_helper.dart';

enum UpdateTaskReason { created, updated, deleted }

class AppUtils {
  static Color getCategoryColor(BuildContext context, String cAlias) {
    if (cAlias == 'grocery') return context.color.grocery;
    if (cAlias == 'educational') return context.color.educational;
    if (cAlias == 'home_related') return context.color.homeRelated;
    if (cAlias == 'work_related') return context.color.workRelated;
    if (cAlias == 'mandatory_work') return context.color.mandatoryWork;
    if (cAlias == 'personal_notes') return context.color.personalNotes;
    if (cAlias == 'hobbies') return context.color.hobbies;
    if (cAlias == 'fitness_health') return context.color.fitnessHealth;
    if (cAlias == 'finance') return context.color.finance;
    return context.color.transparent;
  }

  static String getTranslation(String key, {String? fallback = ""}) {
    final translation = TranslationsHelper().getTranslation(key);

    if (translation != null && translation.isNotEmpty) {
      return translation;
    }

    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }

    return key;
  }

  static void updateTasks(TaskModel task, UpdateTaskReason reason) {
    final List<TaskModel> tasks = SingletonDataProvider().tasks;
    switch (reason) {
      case UpdateTaskReason.created:
        tasks.add(task);
        break;

      case UpdateTaskReason.updated:
        final index = tasks.indexWhere((e) => e.id == task.id);

        if (index != -1) {
          tasks[index] = task;
        }
        break;

      case UpdateTaskReason.deleted:
        tasks.removeWhere((e) => e.id == task.id);
        break;
    }
    recalculateTaskDays();
    recalculateTaskCounter();
  }

  static void recalculateTaskDays() {
    final List<TaskModel> tasks = SingletonDataProvider().tasks;
    final String today = DateTime.now().toIso8601String().split('T').first;

    final List<TaskDayModel> taskDays = [];

    for (final task in tasks) {
      final String dueDate = task.dueDate;

      // Find if a TaskDayModel for this due date already exists.
      TaskDayModel? taskDay;
      for (final day in taskDays) {
        if (day.dueDate == dueDate) {
          taskDay = day;
          break;
        }
      }
      // If no TaskDayModel exists for this due date
      // Create a new one.
      if (taskDay == null) {
        taskDay = TaskDayModel(dueDate: dueDate);

        taskDays.add(taskDay);
      }

      // Completed tasks don't count.
      if (task.completed) {
        continue;
      }
      if (dueDate.compareTo(today) < 0) {
        taskDay.overdue++;
      } else if (dueDate.compareTo(today) > 0) {
        taskDay.scheduled++;
      }
    }

    SingletonDataProvider().taskDaysNotifier.value = taskDays;
  }

  static void recalculateTaskCounter() {
    final List<TaskModel> tasks = SingletonDataProvider().tasks;
    final String today = DateTime.now().toIso8601String().split('T').first;

    final TaskCounter taskCounter = TaskCounter();

    for (final task in tasks) {
      final String dueDate = task.dueDate;

      taskCounter.all++;

      if (dueDate == today) {
        taskCounter.today++;
      }

      if (task.completed) {
        continue;
      }

      if (dueDate.compareTo(today) < 0) {
        taskCounter.overdue++;
      } else if (dueDate.compareTo(today) > 0) {
        taskCounter.scheduled++;
      }
    }

    SingletonDataProvider().taskCounterNotifier.value = taskCounter;
  }
}
