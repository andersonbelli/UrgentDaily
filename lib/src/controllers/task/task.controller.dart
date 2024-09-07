import 'package:flutter/material.dart';

import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../../models/task.model.dart';
import '../base_controller.dart';
import '../home/home.controller.dart';

class TaskController extends BaseController {
  TaskController(this.homeController);

  final HomeController homeController;

  DateTime selectedDate = DateTime.now();
  final TextEditingController title = TextEditingController();

  TaskPriority taskPriority = TaskPriority.IMPORTANT;

  bool isRecursive = false;
  Map<RecursiveDay, bool> selectedDaysOfWeek = {};

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
}
