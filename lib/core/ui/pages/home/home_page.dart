import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/app/app_icons.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/app/app_ui.dart';
import 'package:porfolio_task_calendar_app/core/models/category_model.dart';
import 'package:porfolio_task_calendar_app/core/models/task_day_model.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/calendar_strip_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/card_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/fab_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/looder_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/page_base.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/progress_dialog.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/home/tast_card_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/tasks/create_update_page.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/tasks/task_view_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/api_caller.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/json_parser.dart';
import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/locale_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/singleton_data_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Providers
  final ThemeProvider _themeProvider = ThemeProvider();
  final LocaleProvider _localeProvider = LocaleProvider();
  //Flags
  bool _allowRender = false;
  bool _isLoading = false;
  //Data
  DateTime _searchDate = DateTime.now();
  List<TaskModel> _tasks = [];
  final List<CategoryModel> _categories = SingletonDataProvider().categories;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ProgressDialog.show();
      await _fetchTasks();
      ProgressDialog.dismiss();
      setState(() {
        _allowRender = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: PageBase.home(
        title: '${context.loc.hello} Christos',
        leftSideWidget: AppUI.leftSideWidgetHome(context, _themeProvider, _localeProvider),
        child: _allowRender
            ? Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ValueListenableBuilder<TaskCounter>(
                            valueListenable: SingletonDataProvider().taskCounterNotifier,
                            builder: (context, counters, _) {
                              return _uiMainCards(
                                context.loc.today,
                                counters.today,
                                context.color.todayCardBg,
                                AppIcons.taskToday,
                              );
                            },
                          ),
                          const SizedBox(width: AppNumbers.space),
                          ValueListenableBuilder<TaskCounter>(
                            valueListenable: SingletonDataProvider().taskCounterNotifier,
                            builder: (context, counters, _) {
                              return _uiMainCards(
                                context.loc.scheduled,
                                counters.scheduled,
                                context.color.scheduledCardBg,
                                AppIcons.taskScheduled,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppNumbers.space),
                      Row(
                        children: [
                          ValueListenableBuilder<TaskCounter>(
                            valueListenable: SingletonDataProvider().taskCounterNotifier,
                            builder: (context, counters, _) {
                              return _uiMainCards(
                                context.loc.all,
                                counters.all,
                                context.color.allCardBg,
                                AppIcons.taskAll,
                              );
                            },
                          ),
                          const SizedBox(width: AppNumbers.space),
                          ValueListenableBuilder<TaskCounter>(
                            valueListenable: SingletonDataProvider().taskCounterNotifier,
                            builder: (context, counters, _) {
                              return _uiMainCards(
                                context.loc.overdue,
                                counters.overdue,
                                context.color.overdueCardBg,
                                AppIcons.taskOverdue,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppNumbers.space),
                      // Calendar Strip Component
                      ValueListenableBuilder<List<TaskDayModel>>(
                        valueListenable: SingletonDataProvider().taskDaysNotifier,
                        builder: (context, days, _) {
                          return CalendarStripComponent(
                            taskDays: days,
                            selectedDate: _searchDate,
                            onDateSelected: _onDateChanged,
                          );
                        },
                      ),
                      const SizedBox(height: AppNumbers.space),
                      Text(
                        DateTime.now().toIso8601String().split('T')[0] == _searchDate.toIso8601String().split('T')[0]
                            ? context.loc.todays_tasks
                            : "${_searchDate.toIso8601String().split('T')[0]} ${context.loc.tasks}",
                        style: TextStyle(fontSize: AppNumbers.getH3(context), fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppNumbers.space),
                      if (_tasks.isNotEmpty) ...[
                        Expanded(
                          child: Column(
                            children: [
                              if (_isLoading) ...[
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: AppNumbers.padding),
                                    child: LoaderComponent(),
                                  ),
                                ),
                              ] else ...[
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = _tasks[index];
                                      return Column(
                                        children: [
                                          TaskCardComponent(
                                            onTap: () async {
                                              await context.goTo(
                                                TaskViewPage(
                                                  task: task,
                                                  onDelete: () async {
                                                    _fetchTasks();
                                                  },
                                                  onUpdate: (String dueDate) async {
                                                    Log.e('___ Due date changed: $dueDate');
                                                    final parsed = DateTime.parse(dueDate);
                                                    setState(() {
                                                      _searchDate = parsed;
                                                    });
                                                  },
                                                  onSubTaskUpdate: (TaskModel task) async {
                                                    task.updatedAt = DateTime.now().toIso8601String();
                                                    final success = await _updateTask(task);
                                                    return success;
                                                  },
                                                ),
                                              );
                                            },
                                            task: task,
                                            categories: _categories,
                                            searchDate: _searchDate,
                                            onCompleteTask: _completeTask,
                                            onUpdateTask: _updateTask,
                                          ),
                                          const SizedBox(height: AppNumbers.space),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ] else ...[
                        Center(child: Image.asset('lib/core/images/no_data.png')),
                        Center(
                          child: Text(
                            context.loc.no_tasks_available,
                            style: TextStyle(fontSize: AppNumbers.getH3(context), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: AppNumbers.padding,
                    child: FabComponent(
                      onPressed: () async {
                        await context.goTo(
                          CreateUpdatePage(
                            onChange: (String dueDate) async {
                              DateTime parsedDate = DateTime.parse(dueDate);
                              setState(() {
                                _searchDate = parsedDate;
                              });
                              await _fetchTasks();
                            },
                          ),
                        );
                      },
                      icon: AppIcons.add,
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  //UI
  Widget _uiMainCards(String title, int count, Color cardColor, IconData icon) {
    return Expanded(
      child: CardComponent(
        radius: AppNumbers.radiusSm,
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppNumbers.spaceSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: context.color.white, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(AppNumbers.paddingSmall),
                  child: Icon(icon, color: cardColor, size: AppNumbers.iconMd(context)),
                ),
              ),
              const SizedBox(height: AppNumbers.padding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(color: context.color.primaryText, fontSize: AppNumbers.getH3(context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$count',
                    style: TextStyle(color: context.color.primaryText, fontSize: AppNumbers.getH3(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchTasks() async {
    Map<String, dynamic> filters = {'due_date': _searchDate.toIso8601String().split('T')[0]};
    final res = await ApiCaller.select(AppConstants.tasks, withUser: true, filters: filters);
    if (res.isSuccessful()) {
      final data = await JSONParser.parseTask.getTasks(res.json);

      setState(() {
        _tasks = data;
      });
    } else {
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.error);
      }
    }
  }

  Future<void> _completeTask(TaskModel task) async {
    Log.e('TASK ID ${task.id} and TITLE');
    TaskModel t = task
      ..completed = !task.completed
      ..updatedAt = DateTime.now().toIso8601String();
    await _updateTask(t);
  }

  Future<bool> _updateTask(TaskModel task) async {
    ProgressDialog.show();

    final res = await ApiCaller.update(AppConstants.tasks, task.toJson(), filters: {'id': task.id});

    if (res.isSuccessful()) {
      ProgressDialog.dismiss();

      AppUtils.updateTasks(task, UpdateTaskReason.updated);

      setState(() {
        final index = _tasks.indexWhere((e) => e.id == task.id);

        if (index != -1) {
          _tasks[index] = task;
        }
      });

      return true;
    }

    ProgressDialog.dismiss();

    if (mounted) {
      context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.error);
    }

    return false;
  }

  Future<void> _onDateChanged(DateTime newDate) async {
    if (newDate == _searchDate) return;
    setState(() {
      _searchDate = newDate;
      _isLoading = true;
    });
    await _fetchTasks();
    setState(() {
      _isLoading = false;
    });
  }
}
