import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/app/app_icons.dart';
import 'package:porfolio_task_calendar_app/core/app/app_ui.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/models/category_model.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/card_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/fab_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/input_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/page_base.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/sub_task_item_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/tasks/create_update_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/api_caller.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/singleton_data_provider.dart';

class TaskViewPage extends StatefulWidget {
  final TaskModel task;
  final Function(String dueDate)? onUpdate;
  final Future<bool> Function(TaskModel task)? onSubTaskUpdate;
  final Future<void> Function() onDelete;
  const TaskViewPage({required this.task, required this.onDelete, super.key, this.onUpdate, this.onSubTaskUpdate});

  @override
  State<TaskViewPage> createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {
  List<CategoryModel> _categories = [];
  TaskModel _task = TaskModel();

  @override
  void initState() {
    _categories = SingletonDataProvider().categories;
    _task = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageBase.normal(
      title: context.loc.task_details,
      leftSideWidget: AppUI.deleteButton(context, () async {
        if (await _deleteTask()) {
          await widget.onDelete();
          if (context.mounted) {
            await context.pop();
          }
        }
      }),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: double.infinity),
                Text(
                  _task.title,
                  style: TextStyle(
                    fontSize: AppNumbers.title(context),
                    fontWeight: FontWeight.bold,
                    color: context.color.primaryText,
                  ),
                ),
                const SizedBox(height: AppNumbers.space),
                Row(
                  children: [
                    AppUI.categoryCard(context, _categories, _task, expanded: true),
                    const SizedBox(width: AppNumbers.space),
                    AppUI.statusCard(context, _task),
                  ],
                ),
                const SizedBox(height: AppNumbers.space),
                Row(
                  children: [
                    Expanded(
                      child: InputComponent(
                        title: context.loc.date,
                        controller: TextEditingController(text: _task.dueDate),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: AppNumbers.space),
                    Expanded(
                      child: InputComponent(
                        title: context.loc.time,
                        controller: TextEditingController(text: _task.dueTime),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                if (_task.subTasks.isNotEmpty) ...[
                  const SizedBox(height: AppNumbers.space),
                  Padding(
                    padding: const EdgeInsets.only(left: AppNumbers.space),
                    child: Text(
                      context.loc.subtasks,
                      style: TextStyle(
                        fontSize: AppNumbers.body(context),
                        fontWeight: FontWeight.bold,
                        color: context.color.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppNumbers.spaceSmall),
                  CardComponent(
                    child: Column(
                      children: List.generate(_task.subTasks.length, (index) {
                        final subTask = _task.subTasks[index];
                        return SubTaskItemComponent(
                          title: subTask,
                          isDone: _task.subTasksCompleted[index],
                          onTap: () async {
                            final TaskModel t = _task;
                            t.subTasksCompleted[index] = !t.subTasksCompleted[index];
                            final success = await widget.onSubTaskUpdate?.call(t) ?? false;
                            if (!success) {
                              // Handle the failure case, e.g., show a message to the user
                            } else {
                              setState(() {
                                _task.subTasksCompleted[index] = t.subTasksCompleted[index];
                              });
                            }
                          },
                        );
                      }),
                    ),
                  ),
                ],
                InputComponent(
                  title: context.loc.notes,
                  controller: TextEditingController(text: _task.notes.isEmpty ? '-' : _task.notes),
                  description: true,
                  readOnly: true,
                ),
                const SizedBox(height: AppNumbers.space),
              ],
            ),
          ),
          Positioned(
            bottom: AppNumbers.space,
            right: AppNumbers.space,
            child: FabComponent(
              color: context.color.primaryAccent,
              icon: AppIcons.edit,
              isBig: true,
              onPressed: () async {
                await context.goTo(
                  CreateUpdatePage(
                    task: _task,
                    onChange: (dueDate) {
                      widget.onUpdate?.call(dueDate);
                    },
                    onUpdate: (task) {
                      setState(() {
                        _task = task;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _deleteTask() async {
    final res = await ApiCaller.delete(AppConstants.tasks, filters: {'id': _task.id});
    if (res.isSuccessful()) {
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(res.code));
      }
      AppUtils.updateTasks(widget.task, UpdateTaskReason.deleted);
      return true;
    } else {
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(res.code));
      }
      return false;
    }
  }
}
