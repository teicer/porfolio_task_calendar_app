import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/app/app_icons.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/app/app_ui.dart';
import 'package:porfolio_task_calendar_app/core/models/category_model.dart';
import 'package:porfolio_task_calendar_app/core/models/task_day_model.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';
import 'package:porfolio_task_calendar_app/core/models/user_model.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/calendar_strip_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/card_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/fab_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/looder_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/page_base.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/progress_dialog.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/home/tast_card_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/task_by_status/task_by_status_page.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/tasks/create_update_page.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/tasks/task_view_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/api_caller.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/json_parser.dart';
import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/date_time_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/singleton_data_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: '${context.loc.hello} ${UserModel().name.isEmpty ? context.loc.friend : UserModel().name}',
        leftSideWidget: AppUI.leftSideWidgetHome(context, () {
          if (context.mounted) {
            setState(() {});
          }
        }),
        child: _allowRender
            ? Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: SingletonDataProvider().cardsUpNotifier,
                        builder: (context, cardsUp, _) {
                          return AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: cardsUp ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                            sizeCurve: Curves.easeInOutCubic,
                            firstChild: Column(
                              children: [
                                Row(
                                  children: [
                                    ValueListenableBuilder<TaskCounter>(
                                      valueListenable: SingletonDataProvider().taskCounterNotifier,
                                      builder: (context, counters, _) {
                                        return _uiMainCardsUp(
                                          context.loc.today,
                                          counters.today,
                                          context.color.todayCardBg,
                                          AppIcons.taskToday,
                                          TaskStatus.today,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: AppNumbers.space),
                                    ValueListenableBuilder<TaskCounter>(
                                      valueListenable: SingletonDataProvider().taskCounterNotifier,
                                      builder: (context, counters, _) {
                                        return _uiMainCardsUp(
                                          context.loc.scheduled,
                                          counters.scheduled,
                                          context.color.scheduledCardBg,
                                          AppIcons.taskScheduled,
                                          TaskStatus.scheduled,
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
                                        return _uiMainCardsUp(
                                          context.loc.all,
                                          counters.all,
                                          context.color.allCardBg,
                                          AppIcons.taskAll,
                                          TaskStatus.all,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: AppNumbers.space),
                                    ValueListenableBuilder<TaskCounter>(
                                      valueListenable: SingletonDataProvider().taskCounterNotifier,
                                      builder: (context, counters, _) {
                                        return _uiMainCardsUp(
                                          context.loc.overdue,
                                          counters.overdue,
                                          context.color.overdueCardBg,
                                          AppIcons.taskOverdue,
                                          TaskStatus.overdue,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            secondChild: const SizedBox(width: double.infinity, height: 0),
                          );
                        },
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
                            : "${context.loc.tasks}: ${DateFormatProvider().format(_searchDate)}",
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
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable: SingletonDataProvider().cardsUpNotifier,
                                    builder: (context, cardsUp, _) {
                                      return ListView.builder(
                                        padding: EdgeInsets.only(bottom: !cardsUp ? 100 : AppNumbers.padding),
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
                    bottom: AppNumbers.padding,
                    right: 0,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: SingletonDataProvider().cardsUpNotifier,
                      builder: (context, cardsUp, _) {
                        return AnimatedScale(
                          scale: cardsUp ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOutBack,
                          child: AnimatedOpacity(
                            opacity: cardsUp ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: IgnorePointer(
                              ignoring: !cardsUp,
                              child: FabComponent(
                                onPressed: () async {
                                  await context.goTo(
                                    CreateUpdatePage(
                                      onChange: (String dueDate) async {
                                        final parsedDate = DateTime.parse(dueDate);
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
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: SingletonDataProvider().cardsUpNotifier,
                      builder: (context, cardsUp, _) {
                        return AnimatedSlide(
                          offset: !cardsUp ? Offset.zero : const Offset(0, 1.2),
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: !cardsUp ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: IgnorePointer(
                              ignoring: cardsUp,
                              child: CardComponent(
                                padding: AppNumbers.space,
                                color: context.color.overBg.withAlpha(150),
                                child: Row(
                                  children: [
                                    ValueListenableBuilder<TaskCounter>(
                                      valueListenable: SingletonDataProvider().taskCounterNotifier,
                                      builder: (context, counters, _) {
                                        return _uiMainCardsDown(
                                          context.loc.today,
                                          counters.today,
                                          context.color.todayCardBg,
                                          AppIcons.taskToday,
                                          TaskStatus.today,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: AppNumbers.space),
                                    ValueListenableBuilder<TaskCounter>(
                                      valueListenable: SingletonDataProvider().taskCounterNotifier,
                                      builder: (context, counters, _) {
                                        return _uiMainCardsDown(
                                          context.loc.scheduled,
                                          counters.scheduled,
                                          context.color.scheduledCardBg,
                                          AppIcons.taskScheduled,
                                          TaskStatus.scheduled,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: AppNumbers.space),
                                    ValueListenableBuilder<TaskCounter>(
                                      valueListenable: SingletonDataProvider().taskCounterNotifier,
                                      builder: (context, counters, _) {
                                        return _uiMainCardsDown(
                                          context.loc.all,
                                          counters.all,
                                          context.color.allCardBg,
                                          AppIcons.taskAll,
                                          TaskStatus.all,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: AppNumbers.space),
                                    ValueListenableBuilder<TaskCounter>(
                                      valueListenable: SingletonDataProvider().taskCounterNotifier,
                                      builder: (context, counters, _) {
                                        return _uiMainCardsDown(
                                          context.loc.overdue,
                                          counters.overdue,
                                          context.color.overdueCardBg,
                                          AppIcons.taskOverdue,
                                          TaskStatus.overdue,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: AppNumbers.space),
                                    FabComponent(
                                      onPressed: () async {
                                        await context.goTo(
                                          CreateUpdatePage(
                                            onChange: (String dueDate) async {
                                              final parsedDate = DateTime.parse(dueDate);
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  //UI
  Widget _uiMainCardsUp(String title, int count, Color cardColor, IconData icon, TaskStatus status) {
    return Expanded(
      child: CardComponent(
        onTap: () async {
          await context.goTo(TaskByStatusPage(reason: status));
        },
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

  Widget _uiMainCardsDown(String title, int count, Color cardColor, IconData icon, TaskStatus status) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          await context.goTo(TaskByStatusPage(reason: status));
        },
        borderRadius: BorderRadius.circular(AppNumbers.radius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppNumbers.paddingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: context.color.primaryText, size: AppNumbers.iconMd(context)),
                  Positioned(
                    top: -5,
                    right: -9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(
                        '$count',
                        style: TextStyle(color: context.color.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: context.color.secondaryText,
                  fontSize: AppNumbers.caption(context),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
