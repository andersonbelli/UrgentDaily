import 'package:injectable/injectable.dart';

import '../../helpers/config/di.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../models/task.model.dart';
import '../../services/home/tasks.service.dart';
import '../base_controller.dart';

@Singleton()
class HomeController extends BaseController {
  HomeController() {
    loadUserTasks();
  }

  final TasksService _tasksService = getIt<TasksService>();

  /// Current Date state
  late DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  Future<void> updateSelectedDate(DateTime newSelectedDate) async {
    if (newSelectedDate == _selectedDate) return;

    _selectedDate = newSelectedDate;

    notifyListeners();
  }

  /// Tasks state
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  /// Priority lists
  final List<Task> urgentTasks = [],
      importantTasks = [],
      importantNotUrgentTasks = [],
      notImportantTasks = [];

  void addTask(Task taskToAdd) async {
    toggleLoading();

    final task = await _tasksService.addTask(taskToAdd);
    _tasks.add(task);

    notifyListeners();
    toggleLoading();
  }

  void removeTask(Task taskToRemove) async {
    toggleLoading();

    final task = await _tasksService.removeTask(taskToRemove);
    _tasks.remove(task);

    notifyListeners();
    toggleLoading();
  }

  void editTask(Task editedTask) async {
    toggleLoading();

    await _tasksService.editTask(editedTask);

    _tasks[_getTaskIndex(editedTask)] = editedTask;

    notifyListeners();
    toggleLoading();
  }

  void toggleCompletedTask(Task task, bool? isCompleted) {
    if (isCompleted != null) {
      _tasks[_getTaskIndex(task)] = task.copyWith(isCompleted: isCompleted);
      notifyListeners();
    }
  }

  int _getTaskIndex(Task task) => _tasks.indexWhere((t) => t.id == task.id);

  void loadUserTasks() async {
    toggleLoading();

    final userTasks = await _tasksService.loadTasks(selectedDate);
    _tasks.addAll(userTasks.tasks);

    _separateTasksByPriority();

    notifyListeners();
    toggleLoading();
  }

  void _separateTasksByPriority() {
    urgentTasks.addAll(_getTasksFromSection(TaskPriority.URGENT));
    importantTasks.addAll(_getTasksFromSection(TaskPriority.IMPORTANT));
    importantNotUrgentTasks.addAll(
      _getTasksFromSection(
        TaskPriority.IMPORTANT_NOT_URGENT,
      ),
    );
    notImportantTasks.addAll(
      _getTasksFromSection(
        TaskPriority.NOT_IMPORTANT,
      ),
    );
  }

  List<Task> _getTasksFromSection(TaskPriority priority) => List.from(
        tasks.where(
          (task) => task.priority == priority,
        ),
      );
}
