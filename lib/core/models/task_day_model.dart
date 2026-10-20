class TaskDayModel {
  final String dueDate;
  int overdue;
  int scheduled;

  TaskDayModel({required this.dueDate, this.overdue = 0, this.scheduled = 0});
}

class TaskCounter {
  int overdue;
  int scheduled;
  int all;
  int today;

  TaskCounter({this.overdue = 0, this.scheduled = 0, this.all = 0, this.today = 0});
}
