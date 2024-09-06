import 'package:flutter/material.dart';

import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../base_controller.dart';

class TaskController extends BaseController with ChangeNotifier {
  final TextEditingController title = TextEditingController();

  TaskPriority taskPriority = TaskPriority.IMPORTANT;

  bool isRecursive = false;
  Map<RecursiveDay, bool> selectedDaysOfWeek = {};

  /// Task state
  void toggleRecursive({bool? recursive}) {
    if (recursive == null) {
      isRecursive = !isRecursive;
    } else {
      isRecursive = recursive;
    }

    notifyListeners();
  }

  void selectRecursiveDay(RecursiveDay day, bool selected) {
    selectedDaysOfWeek[day] = selected;
    notifyListeners();
  }

  void selectTaskPriority(TaskPriority? priority) {
    if (priority != null) {
      taskPriority = priority;
      print('task ' + taskPriority.name);
    }
    notifyListeners();
  }
}
