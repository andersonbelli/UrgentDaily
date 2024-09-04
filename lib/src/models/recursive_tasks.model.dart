import '../helpers/enums/recursive_days.enum.dart';
import 'task.model.dart';

class RecursiveTasks {
  final Map<RecursiveDay, List<Task>> recursiveTasksForDay;

  RecursiveTasks(this.recursiveTasksForDay);
}
