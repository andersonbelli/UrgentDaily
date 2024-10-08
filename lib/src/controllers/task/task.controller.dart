import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:injectable/injectable.dart';

import '../../helpers/config/di.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../../models/task.model.dart';
import '../base_controller.dart';
import '../home/home.controller.dart';

enum ErrorFieldsEnum {
  TITLE,
  DAYS_OF_WEEK,
}

@Singleton()
class TaskController extends BaseController {
  final HomeController homeController = getIt<HomeController>();

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
  void editTaskData(Task task) {
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
    final Map<RecursiveDay, bool> newSelectedDays =
        Map.from(selectedDaysOfWeek);
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
    taskId != null ? _editTask() : _createTask();

    notifyListeners();
  }

  void _createTask() => homeController.addTask(
        Task(
          title: title.text,
          date: selectedDate,
          isRecursive: isRecursive,
          recursiveDays: selectedDaysOfWeek,
          priority: taskPriority,
        ),
      );

  void _editTask() => homeController.editTask(
        Task(
          id: taskId,
          title: title.text,
          date: selectedDate,
          isRecursive: isRecursive,
          recursiveDays: selectedDaysOfWeek,
          priority: taskPriority,
        ),
      );

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
      validationErrorMessages[ErrorFieldsEnum.TITLE] =
          '${AppLocalizations.of(context)?.titleIsMandatory}';
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

  bool isRecursiveDaysValid() =>
      selectedDaysOfWeek.containsValue(true) ? true : false;
}
