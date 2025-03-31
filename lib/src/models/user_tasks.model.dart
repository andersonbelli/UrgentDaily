import 'task.model.dart';

class UserTasks {
  final DateTime date;
  final List<Task> tasks;

  UserTasks({required this.tasks, required this.date});

  UserTasks copyWith({
    DateTime? date,
    List<Task>? tasks,
  }) =>
      UserTasks(
        date: date ?? this.date,
        tasks: tasks ?? this.tasks,
      );

  factory UserTasks.fromListOfTasks({
    required List<Task> tasks,
    required DateTime date,
  }) =>
      UserTasks(
        tasks: tasks,
        date: date,
      );

  factory UserTasks.orderTasksByPriority({
    required List<Task> tasks,
    required DateTime date,
  }) {
    final userTasks = UserTasks.fromListOfTasks(
      tasks: List.from(tasks),
      date: date,
    );
    userTasks.tasks.sort(
      (a, b) => a.priority.index.compareTo(b.priority.index),
    );
    return userTasks;
  }
}
