import 'package:injectable/injectable.dart';

import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';

@Injectable()
class TasksService {
  Future<Task> addTask(Task task) async {
    /// TODO: Replace with Repository => addTask
    // tasksRepository.addTask(task)

    await Future.delayed(const Duration(seconds: 2));

    return task;
  }

  Future<Task> removeTask(Task task) async {
    /// TODO: Replace with Repository => removeTask
    // tasksRepository.removeTask(task)

    return task;
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

    return Future.value(MockUserTasks.userTasks);
  }

  Future<List<UserTasks>> loadTasksForTwoWeeks() {
    final day1 = MockUserTasks.userTasks
        .copyWith(date: DateTime.now().subtract(const Duration(days: 3)));

    return Future.value(
      [day1, MockUserTasks.userTasks],
    );
  }
}
