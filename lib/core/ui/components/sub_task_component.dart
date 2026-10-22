import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/input_component.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

class SubTasksComponent extends StatefulWidget {
  final List<String> initialSubTasks;
  final ValueChanged<List<String>> onChanged;
  final bool topPadding;

  const SubTasksComponent({super.key, required this.initialSubTasks, required this.onChanged, this.topPadding = true});

  @override
  State<SubTasksComponent> createState() => _SubTasksComponentState();
}

class _SubTasksComponentState extends State<SubTasksComponent> {
  late List<String> _subTasks;

  @override
  void initState() {
    super.initState();
    _subTasks = List.from(widget.initialSubTasks);
  }

  void _notifyChange() {
    widget.onChanged(List.unmodifiable(_subTasks));
  }

  Future<void> _showItemDialog({int? index}) async {
    final isEditing = index != null;
    final textController = TextEditingController(text: isEditing ? _subTasks[index] : '');

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.color.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppNumbers.radius)),
        title: Text(
          isEditing ? context.loc.edit_sub_task : context.loc.add_sub_task,
          style: TextStyle(color: ctx.color.primaryText, fontWeight: FontWeight.bold, fontSize: AppNumbers.getH3(ctx)),
        ),

        content: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppNumbers.padding),
            child: InputComponent(
              title: context.loc.title,
              controller: textController,
              hint: context.loc.enter_sub_task,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              context.loc.cancel,
              style: TextStyle(color: ctx.color.secondaryText, fontSize: AppNumbers.body(ctx)),
            ),
          ),
          TextButton(
            onPressed: () {
              final text = textController.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(ctx, text);
              }
            },
            child: Text(
              isEditing ? context.loc.save : context.loc.add,
              style: TextStyle(
                color: ctx.color.primaryAccent,
                fontWeight: FontWeight.bold,
                fontSize: AppNumbers.body(ctx),
              ),
            ),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        if (isEditing) {
          _subTasks[index] = result;
        } else {
          _subTasks.add(result);
        }
      });
      _notifyChange();
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _subTasks.removeAt(index);
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.topPadding ? const EdgeInsets.only(top: AppNumbers.space) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppNumbers.space),
            child: Text(
              context.loc.subtasks,
              style: TextStyle(
                color: context.color.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: AppNumbers.body(context),
              ),
            ),
          ),
          const SizedBox(height: AppNumbers.spaceSmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppNumbers.padding, vertical: AppNumbers.paddingSmall),
            decoration: BoxDecoration(
              color: context.color.overBg,
              borderRadius: BorderRadius.circular(AppNumbers.radius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _subTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppNumbers.spaceSmall),
                  itemBuilder: (context, index) {
                    final itemText = _subTasks[index];
                    return Row(
                      children: [
                        Icon(
                          Icons.remove_rounded,
                          color: context.color.secondaryText,
                          size: AppNumbers.body(context) * 1.2,
                        ),
                        const SizedBox(width: AppNumbers.space),
                        Expanded(
                          child: Text(
                            itemText,
                            style: TextStyle(color: context.color.primaryText, fontSize: AppNumbers.body(context)),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.edit_outlined,
                            size: AppNumbers.body(context) * 1.1,
                            color: context.color.secondaryText,
                          ),
                          onPressed: () => _showItemDialog(index: index),
                        ),
                        const SizedBox(width: AppNumbers.space),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            size: AppNumbers.body(context) * 1.1,
                            color: context.color.secondaryText,
                          ),
                          onPressed: () => _deleteItem(index),
                        ),
                      ],
                    );
                  },
                ),
                if (_subTasks.isNotEmpty) const SizedBox(height: AppNumbers.space),
                GestureDetector(
                  onTap: () => _showItemDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppNumbers.paddingSmall,
                      vertical: AppNumbers.spaceSmall,
                    ),
                    decoration: BoxDecoration(
                      color: context.color.bg,
                      borderRadius: BorderRadius.circular(AppNumbers.radius),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: AppNumbers.caption(context) * 1.2, color: context.color.primaryAccent),
                        const SizedBox(width: AppNumbers.spaceSmall),
                        Text(
                          context.loc.add_sub_task,
                          style: TextStyle(
                            color: context.color.primaryAccent,
                            fontSize: AppNumbers.caption(context) * 1.1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
