import 'dart:developer';

import 'package:flutter/material.dart';

import '../../helpers/di/di.dart';
import '../../helpers/enums/error_fields/task_error_fields.enum.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../../helpers/enums/task_error_type.enum.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../../helpers/typedefs/error_messages.typedef.dart';
import '../../localization/localization.dart';
import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';
import '../../services/auth/auth.service.dart';
import '../../services/home/tasks.service.dart';
import '../base_controller.dart';

class TaskController extends BaseController {
  /// Task properties
  String? taskId;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime newSelectedDate) {
    if (newSelectedDate.formatDate() == _selectedDate.formatDate()) return;
    _selectedDate = newSelectedDate;
    notifyListeners();
  }

  final TextEditingController title = TextEditingController();
  TaskPriority taskPriority = TaskPriority.IMPORTANT;
  bool isRecursive = false;
  Map<RecursiveDay, bool> selectedDaysOfWeek = {};

  /// Task Edit property
  String originalTitle = '';

  /// Field validation
  ErrorMessagesMap<TaskErrorFieldsEnum> fieldsValidationErrorMessages = {};

  /// Task state
  final TasksService _tasksService;
  late Task classTask;

  late final String _userId = getIt.get<AuthService>().user.uid;

  TaskController({required TasksService tasksService}) : _tasksService = tasksService;

  void taskData({Task? task}) {
    if (task != null) {
      taskId = task.id;
      title.text = task.title;
      originalTitle = task.title;
      selectedDate = task.date?.convertStringToDateTime() ?? DateTime.now();
      isRecursive = task.isRecursive;
      selectedDaysOfWeek = task.recursiveDays;
      taskPriority = task.priority;

      classTask = task;
    } else {
      classTask = Task(
        id: taskId,
        userId: _userId,
        title: title.text,
        date: selectedDate.formatDate(),
        fullDate: selectedDate,
        isRecursive: isRecursive,
        recursiveDays: selectedDaysOfWeek,
        priority: taskPriority,
      );
    }
    notifyListeners();
  }

  void toggleRecursive({bool? recursive}) {
    isRecursive = recursive ?? !isRecursive;
    removeValidationError(TaskErrorFieldsEnum.DAYS_OF_WEEK);
    notifyListeners();
  }

  void selectDate(DateTime newDate) {
    selectedDate = newDate;
    notifyListeners();
  }

  void selectRecursiveDay(RecursiveDay day, bool selected) {
    selectedDaysOfWeek = Map.from(selectedDaysOfWeek)..[day] = selected;
    removeValidationError(TaskErrorFieldsEnum.DAYS_OF_WEEK);
    notifyListeners();
  }

  void selectTaskPriority(TaskPriority? priority) {
    if (priority != null) {
      taskPriority = priority;
      notifyListeners();
    }
  }

  Future<Task?> createTask() async {
    return apiCall<Task>(
      callHandler: () async {
        final task = await _tasksService.addTask(classTask);
        classTask = task;
        notifyListeners();
        return task;
      },
      errorHandler: (error, stack) {
        log('Create Task Error - $runtimeType: $error\n$stack');
        showToastMessage(TaskErrorType.FAILED_TO_CREATE.message);
      },
    );
  }

  Future<void> editTask() async {
    final Task taskToBeEdited = Task(
      id: taskId,
      userId: _userId,
      title: title.text,
      date: selectedDate.formatDate(),
      isRecursive: isRecursive,
      recursiveDays: selectedDaysOfWeek,
      priority: taskPriority,
    );

    classTask = taskToBeEdited;

    await apiCall<Task>(
      callHandler: () async {
        final editedTask = await _tasksService.editTask(classTask);
        await loadTasksForDate(editedTask.date!.convertStringToDateTime());
        return editedTask;
      },
      errorHandler: (error, stack) {
        log('Edit Task Error - $runtimeType: $error\n$stack');
        showToastMessage(TaskErrorType.FAILED_TO_UPDATE.message);
      },
    );
    if (!isUserLoggedIn) {
      showToastMessage(t.loginToSaveYourTasks);
    }
  }

  Future<bool> removeTask() async =>
      await apiCall<bool>(
        callHandler: () async => _tasksService.removeTask(classTask),
        errorHandler: (error, stack) {
          log('Remove Task Error - $runtimeType: $error\n$stack');
          showToastMessage(TaskErrorType.FAILED_TO_DELETE.message);
        },
      ) ??
      false;

  Future<UserTasks?> loadTasksForDate(DateTime date) async {
    return apiCall<UserTasks?>(
      callHandler: () => _tasksService.loadTasks(date),
      errorHandler: (error, stack) {
        log('Load Tasks For Date Error - $runtimeType: $error\n$stack');
        showToastMessage(TaskErrorType.INTERNAL_SERVER_ERROR.message);
      },
    );
  }

  Future<List<UserTasks>> loadTasksForTwoWeeks(DateTime first, DateTime last) async {
    final List<UserTasks> twoWeeksTasks = [];

    final userTwoWeeksTasks = await apiCall<List<UserTasks>>(
      callHandler: () => _tasksService.loadTasksForTwoWeeks(first, last),
      errorHandler: (error, stack) {
        log('Load Tasks For Two Weeks Error - $runtimeType: $error\n$stack');

        showToastMessage(TaskErrorType.INTERNAL_SERVER_ERROR.message);
      },
    );
    if (userTwoWeeksTasks != null) {
      twoWeeksTasks.addAll(userTwoWeeksTasks);
    }

    return twoWeeksTasks;
  }

  void clearTaskData() {
    taskId = null;
    title.clear();
    selectedDate = DateTime.now();
    isRecursive = false;
    taskPriority = TaskPriority.IMPORTANT;
    selectedDaysOfWeek.clear();
    fieldsValidationErrorMessages.clear();
    notifyListeners();
  }

  /// Field validation
  void validateFields() {
    if (title.text.isEmpty && !fieldsValidationErrorMessages.containsKey(TaskErrorFieldsEnum.TITLE)) {
      fieldsValidationErrorMessages[TaskErrorFieldsEnum.TITLE] = TaskErrorFieldsEnum.TITLE.message;
    }

    if (isRecursive && !isRecursiveDaysValid()) {
      fieldsValidationErrorMessages[TaskErrorFieldsEnum.DAYS_OF_WEEK] = TaskErrorFieldsEnum.DAYS_OF_WEEK.message;
    }

    notifyListeners();
  }

  void removeValidationError(TaskErrorFieldsEnum field) {
    fieldsValidationErrorMessages.remove(field);
    notifyListeners();
  }

  bool isRecursiveDaysValid() => selectedDaysOfWeek.containsValue(true);
}
