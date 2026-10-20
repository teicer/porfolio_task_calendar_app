import 'dart:convert';

import 'package:porfolio_task_calendar_app/core/utils/http/json_base.dart';
import 'package:porfolio_task_calendar_app/core/models/tasks_model.dart';

class ParseTask {
  //   class TasksModel {
  //   String id = "";
  //   String userId = "";
  //   String categoryId = "";
  //   String title = "";
  //   String notes = "";
  //   String createdAt = "";
  //   String updatedAt = "";
  //   List<String> subTasks = [];
  //   List<bool> subTasksCompleted = [];
  //   String dueDate = "";
  //   String dueTime = "";
  //   bool isCompleted = false;
  // }

  Future<List<TaskModel>> getAllTasks(String json) async {
    List<TaskModel> tasks = [];
    final parsedJson = jsonDecode(json);

    if (parsedJson == null || parsedJson.isEmpty) {
      return tasks;
    }

    for (final t in parsedJson) {
      TaskModel task = TaskModel();
      JsonBase b = JsonBase(t);
      task.id = b.getStr("id");
      task.userId = b.getStr("user_id");
      task.categoryId = b.getStr("category_id");
      task.title = b.getStr("title");
      task.notes = b.getStr("notes");
      task.createdAt = b.getStr("created_at");
      task.updatedAt = b.getStr("updated_at");
      task.dueDate = b.getStr("due_date");
      task.dueTime = b.getStr("due_time");
      task.completed = b.getBool("completed");

      if (t["sub_tasks"] != null) {
        task.subTasks = List<String>.from(t["sub_tasks"]);
      }
      if (t["sub_tasks_complete"] != null) {
        task.subTasksCompleted = List<bool>.from(t["sub_tasks_complete"]);
      }

      tasks.add(task);
    }
    return tasks;
  }

  Future<List<TaskModel>> getTasks(String json) async {
    List<TaskModel> tasks = [];
    final parsedJson = jsonDecode(json);

    if (parsedJson == null || parsedJson.isEmpty) {
      return tasks;
    }

    for (final t in parsedJson) {
      TaskModel task = TaskModel();
      JsonBase b = JsonBase(t);
      task.id = b.getStr("id");
      task.userId = b.getStr("user_id");
      task.categoryId = b.getStr("category_id");
      task.title = b.getStr("title");
      task.notes = b.getStr("notes");
      task.createdAt = b.getStr("created_at");
      task.updatedAt = b.getStr("updated_at");
      task.dueDate = b.getStr("due_date");
      task.dueTime = b.getStr("due_time");
      task.completed = b.getBool("completed");

      if (t["sub_tasks"] != null) {
        task.subTasks = List<String>.from(t["sub_tasks"]);
      }
      if (t["sub_tasks_complete"] != null) {
        task.subTasksCompleted = List<bool>.from(t["sub_tasks_complete"]);
      }

      tasks.add(task);
    }
    return tasks;
  }
}
