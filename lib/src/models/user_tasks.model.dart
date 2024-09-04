import 'task.model.dart';

class UserTasks {

  static final mockUserTasks = MockUserTasks.userTasks;

  final List<Task> tasks;

  UserTasks(this.tasks);
}

/// Mock Tasks data
final class MockUserTasks {
  static final UserTasks userTasks = UserTasks(Task.mockTasksList);
}


