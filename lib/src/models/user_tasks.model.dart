import 'task.model.dart';

class UserTasks {
  static final mockUserTasks = MockUserTasks.userTasks;

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
  static UserTasks userTasks =
      UserTasks(tasks: Task.mockTasksList, date: DateTime.now());
}
