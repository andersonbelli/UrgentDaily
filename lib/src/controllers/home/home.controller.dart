import 'dart:developer';

import '../../helpers/enums/priority.enum.dart';
import '../../localization/localization.dart';
import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';
import '../../services/home/tasks.service.dart';
import '../base_controller.dart';
import '../task/task.controller.dart';

class HomeController extends BaseController {
  HomeController({
    required this.taskController,
    required this.tasksService,
  }) {
    loadUserTasks();
  }

  final TasksService tasksService;

  final TaskController taskController; // TODO: REMOVE THIS DEPENDCY

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

  String validateError(String errorMessage) {
    errorMessage = errorMessage.toLowerCase();

    return 't.failedToLoadTasks';
  }

  void addTask(Task task) async {
    toggleLoading();

    taskController.taskData(task: task);
    await taskController.createTask();

    _tasks.add(task);

    final listToAdd = _listOfTaskDependingOnPriority(task);
    listToAdd.add(task);

    final sortedListToAdd = UserTasks.orderTasksByPriority(
      tasks: listToAdd,
      date: selectedDate,
    ).tasks;

    listToAdd.clear();
    listToAdd.addAll(sortedListToAdd);

    final sortedTasks = UserTasks.orderTasksByPriority(
      tasks: _tasks,
      date: selectedDate,
    ).tasks;

    _tasks.clear();
    _tasks.addAll(sortedTasks);

    notifyListeners();
    toggleLoading();
  }

  void removeTask(Task taskToRemove) async {
    toggleLoading();

    taskController.taskData(task: taskToRemove);
    final taskHasBeenRemoved = await taskController.removeTask();

    if (taskHasBeenRemoved) {
      _tasks.remove(taskToRemove);

      final listToRemove = _listOfTaskDependingOnPriority(taskToRemove);
      listToRemove.remove(taskToRemove);

      notifyListeners();
    } else {
      log('ERROR: Task has not been removed');
    }

    toggleLoading();
  }

  void editTask(Task task) async {
    toggleLoading();

    _tasks[_getTaskIndex(task, _tasks)] = task;

    final listToEdit = _listOfTaskDependingOnPriority(task);
    listToEdit[_getTaskIndex(task, listToEdit)] = task;

    notifyListeners();
    toggleLoading();
  }

  void toggleCompletedTask(Task task, bool? isCompleted) {
    if (isCompleted != null) {
      task = task.copyWith(isCompleted: isCompleted);

      _tasks[_getTaskIndex(task, _tasks)] = task;

      final listToUpdate = _listOfTaskDependingOnPriority(task);
      listToUpdate[_getTaskIndex(task, listToUpdate)] = task;

      taskController.taskData(task: task);
      taskController.editTask();

      notifyListeners();
    }
  }

  void clearTasksLists() {
    _tasks.clear();
    urgentTasks.clear();
    importantTasks.clear();
    importantNotUrgentTasks.clear();
    notImportantTasks.clear();
  }

  /// Priority lists
  final List<Task> urgentTasks = [], importantTasks = [], importantNotUrgentTasks = [], notImportantTasks = [];

  List<Task> _listOfTaskDependingOnPriority(Task task) {
    switch (task.priority) {
      case TaskPriority.URGENT:
        return urgentTasks;
      case TaskPriority.IMPORTANT:
        return importantTasks;
      case TaskPriority.IMPORTANT_NOT_URGENT:
        return importantNotUrgentTasks;
      case TaskPriority.NOT_IMPORTANT:
        return notImportantTasks;
    }
  }

  int _getTaskIndex(Task task, List<Task> listOfTasks) => listOfTasks.indexWhere((t) => t.id == task.id);

  Future<void> loadUserTasks() async {
    clearTasksLists();

    await apiCall(
      callHandler: () async {
        final userTasks = await tasksService.loadTasks(selectedDate);
        if (userTasks != null) {
          _tasks.addAll(userTasks.tasks);

          _separateTasksByPriority();
        }
      },
      errorHandler: (error, stack) {
        log('Load User Tasks Error - $runtimeType: $error\n$stack');
        throw validateError(error);
      },
    );

    notifyListeners();
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
