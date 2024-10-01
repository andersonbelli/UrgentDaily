import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/di/di.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';
import '../../services/home/tasks.service.dart';
import '../base_controller.dart';

enum ErrorFieldsEnum {
  TITLE,
  DAYS_OF_WEEK,
}

class TaskController extends BaseController {
  /// Task properties
  String? taskId;
  DateTime selectedDate = DateTime.now();
  final TextEditingController title = TextEditingController();

  TaskPriority taskPriority = TaskPriority.IMPORTANT;

  bool isRecursive = false;
  Map<RecursiveDay, bool> selectedDaysOfWeek = {};

  /// Task Edit property
  String originalTitle = '';

  /// Filed validation
  Map<ErrorFieldsEnum, String> validationErrorMessages = {};

  /// Task state
  final TasksService _tasksService = getIt<TasksService>();

  void taskData(Task task) {
    taskId = task.id;
    title.text = task.title;
    originalTitle = task.title;
    selectedDate = task.date ?? DateTime.now();
    isRecursive = task.isRecursive;
    selectedDaysOfWeek = task.recursiveDays;
    taskPriority = task.priority;
    notifyListeners();
  }

  void toggleRecursive({bool? recursive}) {
    if (recursive == null) {
      isRecursive = !isRecursive;
    } else {
      isRecursive = recursive;
    }

    removeValidationError(ErrorFieldsEnum.DAYS_OF_WEEK);

    notifyListeners();
  }

  void selectDate(DateTime newDate) {
    selectedDate = newDate;
    notifyListeners();
  }

  void selectRecursiveDay(RecursiveDay day, bool selected) {
    final Map<RecursiveDay, bool> newSelectedDays = Map.from(selectedDaysOfWeek);
    newSelectedDays[day] = selected;
    selectedDaysOfWeek = newSelectedDays;

    removeValidationError(ErrorFieldsEnum.DAYS_OF_WEEK);

    notifyListeners();
  }

  void selectTaskPriority(TaskPriority? priority) {
    if (priority != null) {
      taskPriority = priority;
    }
    notifyListeners();
  }

  void taskAction() {
    taskId != null ? editTask() : createTask();

    notifyListeners();
  }

  Future<Task> createTask() async {
    final Task taskToBeCreated = Task(
      title: title.text,
      date: selectedDate,
      isRecursive: isRecursive,
      recursiveDays: selectedDaysOfWeek,
      priority: taskPriority,
    );
    final createdTask = await _tasksService.addTask(taskToBeCreated);

    return createdTask;
  }

  Future<Task> editTask() async {
    final Task taskToBeEdited = Task(
      id: taskId,
      title: title.text,
      date: selectedDate,
      isRecursive: isRecursive,
      recursiveDays: selectedDaysOfWeek,
      priority: taskPriority,
    );

    final editedTask = await _tasksService.editTask(taskToBeEdited);

    return editedTask;
  }

  Future<bool> removeTask() async {
    final Task taskToBeRemoved = Task(
      id: taskId,
      title: title.text,
      date: selectedDate,
      isRecursive: isRecursive,
      recursiveDays: selectedDaysOfWeek,
      priority: taskPriority,
    );

    final hasTaskBeenRemoved = await _tasksService.removeTask(taskToBeRemoved);

    return hasTaskBeenRemoved;
  }

  Future<UserTasks> loadTasksForDate(DateTime date) async {
    toggleLoading();
    final loadedTasks = await _tasksService.loadTasks(selectedDate);
    toggleLoading();
    return loadedTasks;
  }

  Future<List<UserTasks>> loadTasksForTwoWeeks(DateTime first, DateTime last) async {
    final loadedTasks = await _tasksService.loadTasksForTwoWeeks(
      first,
      last,
    );

    return loadedTasks;
  }

  void clearTaskData() {
    taskId = null;
    title.clear();
    selectedDate = DateTime.now();
    isRecursive = false;
    taskPriority = TaskPriority.IMPORTANT;

    final Map<RecursiveDay, bool> newSelectedDays = Map.from({});
    selectedDaysOfWeek = newSelectedDays;

    validationErrorMessages.clear();

    notifyListeners();
  }

  /// Field validation
  void validateFields(BuildContext context) {
    if (title.text.isEmpty) {
      validationErrorMessages[ErrorFieldsEnum.TITLE] = '${AppLocalizations.of(context)?.titleIsMandatory}';
    }

    if (isRecursive == true) {
      if (isRecursiveDaysValid() == false) {
        validationErrorMessages[ErrorFieldsEnum.DAYS_OF_WEEK] =
            '${AppLocalizations.of(context)?.recursiveTaskSelectOneDay}';
      }
    }

    notifyListeners();
  }

  void removeValidationError(ErrorFieldsEnum field) {
    validationErrorMessages.remove(field);
    notifyListeners();
  }

  bool isRecursiveDaysValid() => selectedDaysOfWeek.containsValue(true) ? true : false;
}
