import '../../helpers/extensions/datetime_formatter.dart';
import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';

class TasksService {
  Future<Task> addTask(Task task) async {
    /// TODO: Replace with Repository => addTask
    // tasksRepository.addTask(task)

    await Future.delayed(const Duration(seconds: 2));

    return task;
  }

  Future<bool> removeTask(Task task) async {
    /// TODO: Replace with Repository => removeTask
    // tasksRepository.removeTask(task)

    return true;
  }

  Future<Task> editTask(Task task) async {
    /// TODO: Replace with Repository => editTask
    // tasksRepository.editTask(task)

    await Future.delayed(const Duration(seconds: 2));

    return task;
  }

  Future<UserTasks> loadTasks(DateTime? date) async {
    // final DateTime? dateTime = date ?? DateTime.now();

    /// TODO: Replace with Repository => loadTasks
    // tasksRepository.loadTasks(dateTime)

    /// TODO: DELETE TEMPORARY CODE!
    final UserTasks userTasksForDate = MockUserTasks.allUserTasks.firstWhere(
      (userTasks) => userTasks.date.formatDate() == date?.formatDate(),
      orElse: () => MockUserTasks.userTasksToday,
    );

    return Future.value(userTasksForDate);
  }

  Future<List<UserTasks>> loadTasksForTwoWeeks(
    DateTime fromDate,
    DateTime toDate,
  ) {
    return Future.value(
      [
        MockUserTasks.userTasksToday,
        MockUserTasks.userTasks19,
        MockUserTasks.userTasks24,
        MockUserTasks.userTasks06,
      ],
    );
  }
}
