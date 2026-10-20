import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/models/category_model.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/button_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/drop_down_component.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/input_component.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/page_base.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/progress_dialog.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/sub_task_component.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/api_caller.dart';
import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/singleton_data_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/services/supabase_service.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateUpdatePage extends StatefulWidget {
  final TaskModel? task;
  final Function(String dueDate)? onChange;
  final Function(TaskModel task)? onUpdate;
  const CreateUpdatePage({super.key, this.task, this.onChange, this.onUpdate});

  @override
  State<CreateUpdatePage> createState() => _CreateUpdatePageState();
}

class _CreateUpdatePageState extends State<CreateUpdatePage> {
  final TextEditingController _cTitle = TextEditingController();
  final TextEditingController _cNotes = TextEditingController();
  List<CategoryModel> _categories = [];
  CategoryModel _category = CategoryModel();
  final TextEditingController _cDueDate = TextEditingController();
  final TextEditingController _cDueDateTime = TextEditingController();
  List<String> _subTasks = [];
  List<bool> _subTasksComplete = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _categories = SingletonDataProvider().categories;

      if (widget.task != null) {
        setState(() {
          _cTitle.text = widget.task!.title;
          _cNotes.text = widget.task!.notes;
          _cDueDate.text = widget.task!.dueDate;
          _cDueDateTime.text = widget.task!.dueTime;
          _category = _categories.firstWhere((c) => c.id == widget.task!.categoryId, orElse: () => CategoryModel());
          _subTasks.addAll(widget.task!.subTasks);
          _subTasksComplete.addAll(widget.task!.subTasksCompleted);
        });
      } else {
        setState(() {
          _cDueDate.text = DateTime.now().toIso8601String().split('T').first;
          _cDueDateTime.text = DateTime.now().toIso8601String().split('T').last.substring(0, 5);
          _category = _categories.isNotEmpty ? _categories.first : CategoryModel();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageBase.normal(
      title: widget.task == null ? context.loc.create_task : context.loc.update_task,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InputComponent(title: context.loc.title, controller: _cTitle, hint: context.loc.title_hint),
                  const SizedBox(height: AppNumbers.space),
                  Row(
                    children: [
                      Expanded(
                        child: InputComponent(
                          title: context.loc.date,
                          controller: _cDueDate,
                          readOnly: true,
                          onClick: () async {
                            await _selectDueDate();
                          },
                        ),
                      ),
                      const SizedBox(width: AppNumbers.space),
                      Expanded(
                        child: InputComponent(
                          title: context.loc.time,
                          controller: _cDueDateTime,
                          readOnly: true,
                          onClick: () async {
                            await _selectDueTime();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppNumbers.space),
                  DropDownComponent<CategoryModel>(
                    title: context.loc.category,
                    items: _categories,
                    value: _category,
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                    labelBuilder: (item) => item.name,
                  ),
                  const SizedBox(height: AppNumbers.space),
                  SubTasksComponent(
                    key: ValueKey('${widget.task?.id}_${_subTasks.length}'),
                    initialSubTasks: _subTasks,
                    onChanged: (subTasks) {
                      setState(() {
                        _subTasks = subTasks;
                        _subTasksComplete = List<bool>.generate(
                          subTasks.length,
                          (index) => index < _subTasksComplete.length ? _subTasksComplete[index] : false,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: AppNumbers.space),
                  InputComponent(
                    title: context.loc.notes,
                    controller: _cNotes,
                    hint: context.loc.notes_hint,
                    description: true,
                  ),
                  const SizedBox(height: AppNumbers.space),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: ButtonComponent(
              title: context.loc.save_task,
              onPressed: () async {
                if (_cTitle.text.isEmpty) {
                  /// handle with message
                  context.snackbar(context.loc.please_fill_all_fields, type: PopupType.error);
                  return;
                }
                if (widget.task != null) {
                  await _updateTask();
                } else {
                  await _createTask();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final initialDate = DateTime.tryParse(_cDueDate.text) ?? DateTime.now();

    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (dialogCtx) {
        DateTime selected = initialDate;
        DateTime focused = initialDate;

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
                      selectedDayPredicate: (day) => isSameDay(day, selected),
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
                    ),
                    const SizedBox(height: AppNumbers.space),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          child: Text('Cancel', style: TextStyle(color: context.color.secondaryText)),
                        ),
                        const SizedBox(width: AppNumbers.spaceSmall),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: context.color.primaryAccent),
                          onPressed: () => Navigator.pop(dialogCtx, selected),
                          child: Text('OK', style: TextStyle(color: context.color.inverseText)),
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

    if (pickedDate != null) {
      setState(() {
        _cDueDate.text = pickedDate.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _selectDueTime() async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (_cDueDateTime.text.isNotEmpty && _cDueDateTime.text.contains(':')) {
      final parts = _cDueDateTime.text.split(':');
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null) {
        initialTime = TimeOfDay(hour: hour, minute: minute);
      }
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!);
      },
    );

    if (pickedTime != null) {
      final hour = pickedTime.hour.toString().padLeft(2, '0');
      final minute = pickedTime.minute.toString().padLeft(2, '0');

      setState(() {
        _cDueDateTime.text = '$hour:$minute';
      });
    }
  }

  Future<void> _createTask() async {
    ProgressDialog.show();
    TaskModel task = TaskModel()
      ..userId = SupabaseService.client.auth.currentUser?.id ?? ''
      ..title = _cTitle.text
      ..categoryId = _category.id
      ..notes = _cNotes.text
      ..createdAt = DateTime.now().toIso8601String()
      ..updatedAt = DateTime.now().toIso8601String()
      ..subTasks = _subTasks
      ..subTasksCompleted = _subTasksComplete
      ..dueDate = _cDueDate.text
      ..dueTime = _cDueDateTime.text;

    if (task.userId.isEmpty) {
      context.snackbar(context.loc.something_went_wrong, type: PopupType.error);
      ProgressDialog.dismiss();
      return;
    }
    Map<String, dynamic> body = task.toJson();
    body.remove('id');

    final res = await ApiCaller.insert(AppConstants.tasks, body);
    if (res.isSuccessful()) {
      ProgressDialog.dismiss();
      AppUtils.updateTasks(task, UpdateTaskReason.created);
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.success);
        if (widget.onChange != null) {
          widget.onChange!(_cDueDate.text);
        }
        await context.pop();
      }
    } else {
      ProgressDialog.dismiss();
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.error);
      }
    }
  }

  Future<void> _updateTask() async {
    ProgressDialog.show();
    final TaskModel task = widget.task!;
    task
      ..title = _cTitle.text
      ..categoryId = _category.id
      ..notes = _cNotes.text
      ..updatedAt = DateTime.now().toIso8601String()
      ..subTasks = _subTasks
      ..subTasksCompleted = _subTasksComplete
      ..dueDate = _cDueDate.text
      ..dueTime = _cDueDateTime.text;

    final res = await ApiCaller.update(AppConstants.tasks, task.toJson(), filters: {'id': task.id});

    if (res.isSuccessful()) {
      Log.e('res code _____  ${res.code}');
      ProgressDialog.dismiss();
      AppUtils.updateTasks(task, UpdateTaskReason.updated);

      if (mounted) {
        if (widget.onUpdate != null) {
          widget.onUpdate!(task);
        }
        if (widget.onChange != null) {
          widget.onChange!(_cDueDate.text);
        }
        if (mounted) {
          context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.success);
        }
        await context.pop();
      } else {
        ProgressDialog.dismiss();
        if (mounted) {
          context.snackbar(AppUtils.getTranslation(res.code), type: PopupType.error);
        }
      }
    }
  }
}
