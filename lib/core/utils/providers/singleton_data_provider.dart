import 'package:flutter/foundation.dart';
import 'package:porfolio_task_calendar_app/core/models/category_model.dart';
import 'package:porfolio_task_calendar_app/core/models/task_day_model.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';

class SingletonDataProvider {
  factory SingletonDataProvider() {
    return _instance;
  }
  static final SingletonDataProvider _instance = SingletonDataProvider._internal();

  SingletonDataProvider._internal();

  List<CategoryModel> categories = [];
  List<TaskModel> tasks = [];

  final ValueNotifier<List<TaskDayModel>> taskDaysNotifier = ValueNotifier<List<TaskDayModel>>([]);
  final ValueNotifier<TaskCounter> taskCounterNotifier = ValueNotifier<TaskCounter>(
    TaskCounter(all: 0, overdue: 0, scheduled: 0, today: 0),
  );

  List<TaskDayModel> get taskDays => taskDaysNotifier.value;
  TaskCounter get taskCounter => taskCounterNotifier.value;
  final ValueNotifier<bool> cardsUpNotifier = ValueNotifier<bool>(true);
  bool get cardsUp => cardsUpNotifier.value;
  set cardsUp(bool val) => cardsUpNotifier.value = val;
}
