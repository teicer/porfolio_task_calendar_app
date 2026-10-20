class TaskModel {
  String id = "";
  String userId = "";
  String categoryId = "";
  String title = "";
  String notes = "";
  String createdAt = "";
  String updatedAt = "";
  List<String> subTasks = [];
  List<bool> subTasksCompleted = [];
  String dueDate = "";
  String dueTime = "";
  bool completed = false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sub_tasks': subTasks,
      'sub_tasks_complete': subTasksCompleted,
      'due_date': dueDate,
      'due_time': dueTime,
      'completed': completed,
    };
  }
}
