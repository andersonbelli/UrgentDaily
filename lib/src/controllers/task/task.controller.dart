import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../../models/task.model.dart';
import '../base_controller.dart';
import '../home/home.controller.dart';

enum ErrorFieldsEnum {
  TITLE,
  DAYS_OF_WEEK,
}

class TaskController extends BaseController {
  TaskController(this.homeController);

  final HomeController homeController;

  DateTime selectedDate = DateTime.now();
  final TextEditingController title = TextEditingController();

  TaskPriority taskPriority = TaskPriority.IMPORTANT;

  bool isRecursive = false;
  Map<RecursiveDay, bool> selectedDaysOfWeek = {};

  Map<ErrorFieldsEnum, String> validationErrorMessages = {};

  /// Task state
  void editTaskData(Task task) {
    title.text = task.title;
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

  void createTask() {
    homeController.addTask(
      Task(
        title: title.text,
        date: selectedDate,
        isRecursive: isRecursive,
        recursiveDays: selectedDaysOfWeek,
        priority: taskPriority,
      ),
    );
    notifyListeners();
  }

  void clearTaskData() {
    title.clear();
    selectedDate = DateTime.now();
    isRecursive = false;
    taskPriority = TaskPriority.IMPORTANT;

    final Map<RecursiveDay, bool> newSelectedDays = Map.from({});
    selectedDaysOfWeek = newSelectedDays;

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
