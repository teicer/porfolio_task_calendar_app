import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_icons.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/app/app_ui.dart';
import 'package:porfolio_task_calendar_app/core/models/category_model.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/card_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/sub_task_item_component.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/date_time_provider.dart';

class TaskCardComponent extends StatefulWidget {
  final TaskModel task;
  final List<CategoryModel> categories;
  final DateTime searchDate;
  final Future<void> Function(TaskModel task) onCompleteTask;
  final Future<bool> Function(TaskModel task) onUpdateTask;
  final VoidCallback? onTap;

  const TaskCardComponent({
    super.key,
    required this.task,
    required this.categories,
    required this.searchDate,
    required this.onCompleteTask,
    required this.onUpdateTask,
    this.onTap,
  });

  @override
  State<TaskCardComponent> createState() => _TaskCardComponentState();
}

class _TaskCardComponentState extends State<TaskCardComponent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return CardComponent(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Positioned(top: 0, right: 0, child: AppUI.categoryCard(context, widget.categories, task)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: context.color.cardBorder, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(AppNumbers.paddingSmall),
                  child: InkWell(
                    onTap: () async {
                      await widget.onCompleteTask(task);
                    },
                    child: Icon(
                      task.completed ? AppIcons.checkFilled : AppIcons.checkOutlined,
                      color: context.color.primaryAccent,
                      size: AppNumbers.iconMd(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppNumbers.spaceSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(AppIcons.calendar, color: context.color.secondaryText, size: AppNumbers.iconXs(context)),
                        const SizedBox(width: AppNumbers.spaceSmall),
                        Text(
                          widget.searchDate.toIso8601String().split('T').first ==
                                  DateTime.now().toIso8601String().split('T').first
                              ? context.loc.today
                              : DateFormatProvider().format(widget.searchDate),
                          style: TextStyle(color: context.color.secondaryText, fontSize: AppNumbers.caption(context)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: AppNumbers.spaceSmall),
                        Icon(AppIcons.clock, color: context.color.secondaryText, size: AppNumbers.iconXs(context)),
                        const SizedBox(width: AppNumbers.spaceSmall),
                        Text(
                          task.dueTime,
                          style: TextStyle(color: context.color.secondaryText, fontSize: AppNumbers.caption(context)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppNumbers.space),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(color: context.color.primaryText, fontSize: AppNumbers.body(context)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (task.subTasks.isNotEmpty) ...[
                          const SizedBox(width: AppNumbers.spaceSmall),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppNumbers.spaceSmall),
                              child: AnimatedRotation(
                                turns: _expanded ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  AppIcons.arrowDown,
                                  color: context.color.secondaryText,
                                  size: AppNumbers.iconMd(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    if (task.subTasks.isNotEmpty) ...[
                      const SizedBox(height: AppNumbers.spaceSmall),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,

                        firstChild: SubTaskItemComponent(
                          isHomePage: true,
                          title: task.subTasks.first,
                          isDone: task.subTasksCompleted.first,
                          onTap: () async {
                            final TaskModel t = task;
                            t.subTasksCompleted[0] = !t.subTasksCompleted[0];
                            final success = await widget.onUpdateTask(t);
                            if (success) {
                              setState(() {
                                task.subTasksCompleted[0] = t.subTasksCompleted[0];
                              });
                            }
                          },
                        ),
                        secondChild: Column(
                          children: List.generate(task.subTasks.length, (index) {
                            final subTask = task.subTasks[index];
                            return SubTaskItemComponent(
                              isHomePage: true,
                              title: subTask,
                              isDone: task.subTasksCompleted[index],
                              onTap: () async {
                                final TaskModel t = task;
                                t.subTasksCompleted[index] = !t.subTasksCompleted[index];
                                final success = await widget.onUpdateTask(t);
                                if (success) {
                                  setState(() {
                                    task.subTasksCompleted[index] = t.subTasksCompleted[index];
                                  });
                                }
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
