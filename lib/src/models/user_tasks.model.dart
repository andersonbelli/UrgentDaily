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
}

/// Mock Tasks data
final class MockUserTasks {
  static UserTasks userTasksToday =
      UserTasks(tasks: Task.mockTasksList1, date: DateTime.utc(2024, 09, 22));

  static UserTasks userTasks24 =
      UserTasks(tasks: Task.mockTasksList2, date: DateTime.utc(2024, 09, 24));

  static UserTasks userTasks19 =
      UserTasks(tasks: Task.mockTasksList3, date: DateTime.utc(2024, 09, 19));

  static UserTasks userTasks06 =
      UserTasks(tasks: Task.mockTasksList2, date: DateTime.utc(2024, 10, 06));
}
