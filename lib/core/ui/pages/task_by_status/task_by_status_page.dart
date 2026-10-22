import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/page_base.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/progress_dialog.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/home/home_page.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/home/tast_card_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/tasks/task_view_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/api_caller.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/json_parser.dart';
import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/singleton_data_provider.dart';

enum TaskStatus { today, scheduled, all, overdue }

class TaskByStatusPage extends StatefulWidget {
  final TaskStatus reason;
  const TaskByStatusPage({super.key, required this.reason});

  @override
  State<TaskByStatusPage> createState() => _TaskByStatusPageState();
}

class _TaskByStatusPageState extends State<TaskByStatusPage> {
  //Flags
  bool _somethingChanged = false;
  bool _allowRender = false;

  //Data
  int _completed = 0;
  int _unCompleted = 0;
  List<TaskModel> _tasks = [];
  final _categories = SingletonDataProvider().categories;
  final DateTime _dueDate = DateTime.now();
  String get _title {
    switch (widget.reason) {
      case TaskStatus.today:
        return context.loc.todays_tasks;
      case TaskStatus.scheduled:
        return context.loc.scheduled_tasks;
      case TaskStatus.all:
        return context.loc.all_tasks;
      case TaskStatus.overdue:
        return context.loc.overdue_tasks;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ProgressDialog.show();
      await _fetchTasks();
      ProgressDialog.dismiss();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) return;

        if (_somethingChanged) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;

            context.goTo(HomePage());
          });
        } else {
          await context.pop();
        }
      },
      child: PageBase.normal(
        title: _title,
        child: _allowRender
            ? Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_tasks.isNotEmpty) ...[
                        Text(
                          '${context.loc.complete_tasks}: $_completed',
                          style: TextStyle(color: context.color.primaryText, fontSize: AppNumbers.body(context)),
                        ),
                        const SizedBox(height: AppNumbers.spaceSmall),
                        Text(
                          '${context.loc.uncomplete_tasks}: $_unCompleted',
                          style: TextStyle(color: context.color.primaryText, fontSize: AppNumbers.body(context)),
                        ),
                        const SizedBox(height: AppNumbers.padding),
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
                                            _somethingChanged = true;
                                            _fetchTasks();
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
                                    searchDate: _dueDate,
                                    onCompleteTask: _completeTask,
                                    onUpdateTask: _updateTask,
                                  ),
                                  const SizedBox(height: AppNumbers.space),
                                ],
                              );
                            },
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
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _completeTask(TaskModel task) async {
    Log.e('TASK ID ${task.id} and TITLE');
    TaskModel t = task
      ..completed = !task.completed
      ..updatedAt = DateTime.now().toIso8601String();
    await _updateTask(t);
  }

  Future<bool> _updateTask(TaskModel task) async {
    _somethingChanged = true;
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

  Future<void> _fetchTasks() async {
    final String dueDateString = _dueDate.toIso8601String().split('T').first;

    final Map<String, dynamic> filters = {};

    switch (widget.reason) {
      case TaskStatus.today:
        filters['due_date'] = dueDateString;
        break;

      case TaskStatus.overdue:
        filters['due_date'] = {r'$lt': dueDateString};
        break;

      case TaskStatus.scheduled:
        filters['due_date'] = {r'$gt': dueDateString};
        break;

      case TaskStatus.all:
        break;
    }
    final res = await ApiCaller.select(AppConstants.tasks, withUser: true, filters: filters);
    if (res.isSuccessful()) {
      final data = await JSONParser.parseTask.getTasks(res.json);
      _completed = data.where((task) => task.completed).length;
      _unCompleted = data.where((task) => !task.completed).length;
      if (mounted) {
        setState(() {
          _tasks = data;
          _allowRender = true;
        });
      }
    } else {
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.error);
      }
    }
  }
}
