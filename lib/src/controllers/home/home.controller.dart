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

    final listToAdd = _listOfTaskDependingOnPriority(taskToAdd);
    listToAdd.add(task);

    notifyListeners();
    toggleLoading();
  }

  List<Task> _listOfTaskDependingOnPriority(Task task) {
    switch (task.priority) {
      case TaskPriority.URGENT:
        return urgentTasks;
      case TaskPriority.IMPORTANT:
        return importantTasks;
      case TaskPriority.IMPORTANT_NOT_URGENT:
        return importantNotUrgentTasks;
      case TaskPriority.NOT_IMPORTANT:
      default:
        return notImportantTasks;
    }
  }

  void removeTask(Task taskToRemove) async {
    toggleLoading();

    final task = await _tasksService.removeTask(taskToRemove);
    _tasks.remove(task);

    final listToRemove = _listOfTaskDependingOnPriority(taskToRemove);
    listToRemove.remove(task);

    notifyListeners();
    toggleLoading();
  }

  void editTask(Task editedTask) async {
    toggleLoading();

    await _tasksService.editTask(editedTask);

    _tasks[_getTaskIndex(editedTask, _tasks)] = editedTask;

    final listToEdit = _listOfTaskDependingOnPriority(editedTask);
    listToEdit[_getTaskIndex(editedTask, listToEdit)] = editedTask;

    notifyListeners();
    toggleLoading();
  }

  void toggleCompletedTask(Task task, bool? isCompleted) {
    if (isCompleted != null) {
      _tasks[_getTaskIndex(task, _tasks)] =
          task.copyWith(isCompleted: isCompleted);

      final listToUpdate = _listOfTaskDependingOnPriority(task);
      listToUpdate[_getTaskIndex(task, listToUpdate)] =
          task.copyWith(isCompleted: isCompleted);

      notifyListeners();
    }
  }

  int _getTaskIndex(Task task, List<Task> listOfTasks) =>
      listOfTasks.indexWhere((t) => t.id == task.id);

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
    notifyListeners();
  }

  List<Task> _getTasksFromSection(TaskPriority priority) => List.from(
        tasks.where(
          (task) => task.priority == priority,
        ),
      );
}
