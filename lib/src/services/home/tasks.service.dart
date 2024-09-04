import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';

class TasksService {
  Future<Task> addTask(Task task) async {
    /// TODO: Replace with Repository => addTask
    // tasksRepository.addTask(task)

    return task;
  }

  Future<Task> removeTask(Task task) async {
    /// TODO: Replace with Repository => removeTask
    // tasksRepository.removeTask(task)

    return task;
  }

  Future<UserTasks> loadTasks(DateTime? date) async {
    // final DateTime? dateTime = date ?? DateTime.now();

    /// TODO: Replace with Repository => loadTasks
    // tasksRepository.loadTasks(dateTime)

    return Future.value(MockUserTasks.userTasks);
  }
}
