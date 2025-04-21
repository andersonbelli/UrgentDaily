import 'dart:developer';

import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/task_error_type.enum.dart';
import '../../models/task.model.dart';
import '../../services/tasks/tasks.service.dart';
import '../base_controller.dart';

class HomeController extends BaseController {
  HomeController({required this.tasksService});

  final TasksService tasksService;

  late DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool isEditMode = false;

  final List<Task> urgentTasks = [], importantTasks = [], importantNotUrgentTasks = [], notPriorityTasks = [];

  void toggleEditMode() {
    isEditMode = !isEditMode;
    notifyListeners();
  }

  Future<void> updateSelectedDate(DateTime newSelectedDate) async {
    if (newSelectedDate == _selectedDate) return;
    _selectedDate = newSelectedDate;
    notifyListeners();
  }

  void removeTask(Task taskToRemove) async {
    await apiCall(
      callHandler: () async {
        final taskHasBeenRemoved = await tasksService.removeTask(taskToRemove);

        if (taskHasBeenRemoved) {
          _tasks.remove(taskToRemove);

          final listToRemove = _listOfTaskDependingOnPriority(taskToRemove);
          listToRemove.remove(taskToRemove);

          notifyListeners();
        }
      },
      errorHandler: (error, stack) {
        log('Remove Task Error - $runtimeType: $error\n$stack');
        _handleTaskError(error);
      },
    );
  }

  void editTask(Task task) async {
    await apiCall(
      callHandler: () async {
        _tasks[_getTaskIndex(task, _tasks)] = task;

        final listToEdit = _listOfTaskDependingOnPriority(task);
        listToEdit[_getTaskIndex(task, listToEdit)] = task;

        await tasksService.editTask(task);
        await loadUserTasks();
      },
      errorHandler: (error, stack) {
        log('Edit Task Error - $runtimeType: $error\n$stack');
        _handleTaskError(error);
      },
    );
  }

  void toggleCompletedTask(Task task, bool? isCompleted) async {
    if (isCompleted == null) return;

    task = task.copyWith(isCompleted: isCompleted);

    await apiCall(
      callHandler: () async {
        _tasks[_getTaskIndex(task, _tasks)] = task;

        final listToUpdate = _listOfTaskDependingOnPriority(task);
        listToUpdate[_getTaskIndex(task, listToUpdate)] = task;

        await tasksService.editTask(task);
        await loadUserTasks();
      },
      errorHandler: (error, stack) {
        log('Toggle Completed Task Error - $runtimeType: $error\n$stack');
        _handleTaskError(error);
      },
    );
  }

  Future<void> loadUserTasks() async {
    // TODO: Implement local data retrieve

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
        _handleTaskError(error);
      },
    );

    notifyListeners();
  }

  void clearTasksLists() {
    _tasks.clear();
    urgentTasks.clear();
    importantTasks.clear();
    importantNotUrgentTasks.clear();
    notPriorityTasks.clear();
  }

  List<Task> _listOfTaskDependingOnPriority(Task task) {
    switch (task.priority) {
      case TaskPriority.URGENT:
        return urgentTasks;
      case TaskPriority.IMPORTANT:
        return importantTasks;
      case TaskPriority.IMPORTANT_NOT_URGENT:
        return importantNotUrgentTasks;
      case TaskPriority.NOT_PRIORITY:
        return notPriorityTasks;
    }
  }

  int _getTaskIndex(Task task, List<Task> listOfTasks) => listOfTasks.indexWhere((t) => t.id == task.id);

  List<Task> _getTasksFromSection(TaskPriority priority) => List.from(
        tasks.where((task) => task.priority == priority),
      );

  void _separateTasksByPriority() {
    urgentTasks.addAll(_getTasksFromSection(TaskPriority.URGENT));
    importantTasks.addAll(_getTasksFromSection(TaskPriority.IMPORTANT));
    importantNotUrgentTasks.addAll(_getTasksFromSection(TaskPriority.IMPORTANT_NOT_URGENT));
    notPriorityTasks.addAll(_getTasksFromSection(TaskPriority.NOT_PRIORITY));
    notifyListeners();
  }

  void _handleTaskError(Object error) {
    String logMessage = 'Unknown error: $error';
    String toastMessage = TaskErrorType.INTERNAL_SERVER_ERROR.message;

    if (error is TaskErrorType) {
      logMessage = 'Task error: ${error.message}';
      toastMessage = error.message;
    }

    log(logMessage);
    showToastMessage(toastMessage);
  }
}
