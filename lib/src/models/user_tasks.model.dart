import 'task.model.dart';

class UserTasks {
  static final mockUserTasks = MockUserTasks.userTasksToday;

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

/// Mock Tasks data
final class MockUserTasks {
  static List<UserTasks> allUserTasks = [
    userTasksToday,
    userTasks24,
    userTasks19,
    userTasks06,
  ];

  static UserTasks userTasksToday =
      UserTasks(tasks: Task.mockTasksList1, date: DateTime.now());

  static UserTasks userTasks24 =
      UserTasks(tasks: Task.mockTasksList2, date: DateTime(2024, 09, 25));

  static UserTasks userTasks19 =
      UserTasks(tasks: Task.mockTasksList3, date: DateTime(2024, 09, 19));

  static UserTasks userTasks06 =
      UserTasks(tasks: Task.mockTasksList2, date: DateTime(2024, 10, 06));
}
