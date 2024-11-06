import 'package:flutter/material.dart';

import '../../helpers/enums/error_fields/task_error_fields.enum.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../../helpers/typedefs/error_messages.typedef.dart';
import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';
import '../../services/home/tasks.service.dart';
import '../base_controller.dart';

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
  ErrorMessagesMap<TaskErrorFieldsEnum> validationErrorMessages = {};

  /// Task state
  final TasksService _tasksService;
  late Task classTask;

  TaskController({required TasksService tasksService})
      : _tasksService = tasksService;

  void taskData({Task? task}) {
    if (task != null) {
      taskId = task.id;
      title.text = task.title;
      originalTitle = task.title;
      selectedDate = task.date ?? DateTime.now();
      isRecursive = task.isRecursive;
      selectedDaysOfWeek = task.recursiveDays;
      taskPriority = task.priority;

      classTask = Task(
        id: taskId,
        title: title.text,
        date: selectedDate,
        isRecursive: isRecursive,
        recursiveDays: selectedDaysOfWeek,
        priority: taskPriority,
      );
    } else {
      classTask = Task(
        id: taskId,
        title: title.text,
        date: selectedDate,
        isRecursive: isRecursive,
        recursiveDays: selectedDaysOfWeek,
        priority: taskPriority,
      );
    }

    notifyListeners();
  }

  void toggleRecursive({bool? recursive}) {
    if (recursive == null) {
      isRecursive = !isRecursive;
    } else {
      isRecursive = recursive;
    }

    removeValidationError(TaskErrorFieldsEnum.DAYS_OF_WEEK);

    notifyListeners();
  }

  void selectDate(DateTime newDate) {
    selectedDate = newDate;
    notifyListeners();
  }

  void selectRecursiveDay(RecursiveDay day, bool selected) {
    final Map<RecursiveDay, bool> newSelectedDays =
        Map.from(selectedDaysOfWeek);
    newSelectedDays[day] = selected;
    selectedDaysOfWeek = newSelectedDays;

    removeValidationError(TaskErrorFieldsEnum.DAYS_OF_WEEK);

    notifyListeners();
  }

  void selectTaskPriority(TaskPriority? priority) {
    if (priority != null) {
      taskPriority = priority;
    }
    notifyListeners();
  }

  Future<Task> createTask() async {
    final createdTask = await _tasksService.addTask(classTask);

    toggleLoading();
    notifyListeners();
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
    classTask = taskToBeEdited;

    final editedTask = await _tasksService.editTask(classTask);

    loadTasksForDate(editedTask.date!);
    return editedTask;
  }

  Future<bool> removeTask() async {
    final hasTaskBeenRemoved = await _tasksService.removeTask(classTask);

    return hasTaskBeenRemoved;
  }

  Future<UserTasks> loadTasksForDate(DateTime date) async {
    toggleLoading();
    final loadedTasks = await _tasksService.loadTasks(date);
    toggleLoading();
    return loadedTasks;
  }

  Future<List<UserTasks>> loadTasksForTwoWeeks(
    DateTime first,
    DateTime last,
  ) async {
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
  void validateFields() {
    if (title.text.isEmpty &&
        !validationErrorMessages.containsKey(TaskErrorFieldsEnum.TITLE)) {
      validationErrorMessages[TaskErrorFieldsEnum.TITLE] =
          TaskErrorFieldsEnum.TITLE.message;
    }

    if (isRecursive == true) {
      if (isRecursiveDaysValid() == false) {
        validationErrorMessages[TaskErrorFieldsEnum.DAYS_OF_WEEK] =
            TaskErrorFieldsEnum.DAYS_OF_WEEK.message;
      }
    }

    notifyListeners();
  }

  void removeValidationError(TaskErrorFieldsEnum field) {
    validationErrorMessages.remove(field);
    notifyListeners();
  }

  bool isRecursiveDaysValid() => selectedDaysOfWeek.containsValue(true);
}
