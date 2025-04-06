import 'package:flutter/material.dart';

import '../../helpers/di/di.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';
import '../base_controller.dart';
import '../task/task.controller.dart';

class CalendarController extends BaseController {
  /// Current Date state
  late final ValueNotifier<DateTime> focusedDate = ValueNotifier(DateTime.now());

  DateTime get getFocusedDate => focusedDate.value;

  Future<void> updateFocusedDate(DateTime newFocusedDate) async {
    if (newFocusedDate == focusedDate.value) return;

    focusedDate.value = newFocusedDate;

    notifyListeners();
  }

  /// Tasks state

  final TaskController taskController = getIt<TaskController>();

  final List<UserTasks> _twoWeeksTasks = [];

  List<UserTasks> get twoWeeksTasks => _twoWeeksTasks;
  bool tasksAlreadyLoaded = false;

  Future<void> loadTasksForTwoWeeks() async {
    final userTasks = await taskController.loadTasksForTwoWeeks(
      _visibleDates.first.convertStringToDateTime(),
      _visibleDates.last.convertStringToDateTime(),
    );

    _twoWeeksTasks.addAll(userTasks);
    for (var i = 0; i < _twoWeeksTasks.length; i++) {
      final sortedTasks = UserTasks.orderTasksByPriority(
        tasks: _twoWeeksTasks[i].tasks,
        date: _twoWeeksTasks[i].date,
      ).tasks;

      _twoWeeksTasks[i] = UserTasks.fromListOfTasks(
        tasks: sortedTasks,
        date: _twoWeeksTasks[i].date,
      );
    }

    if (!tasksAlreadyLoaded) {
      tasksAlreadyLoaded = true;
    }
  }

  /// Tasks of selected day state
  late List<Task> _tasksOfSelectedDay = [];

  List<Task> get tasksOfSelectedDay => _tasksOfSelectedDay;

  updateTasksOfSelectedDay({List<Task>? tasks}) async {
    _tasksOfSelectedDay = [];

    if (tasks != null) {
      _tasksOfSelectedDay = tasks;
    } else {
      final tasksForSelectedDay = _twoWeeksTasks.where(
        (task) => task.date.formatDate() == focusedDate.value.formatDate(),
      );

      if (tasksForSelectedDay.isNotEmpty) {
        _tasksOfSelectedDay = tasksForSelectedDay.first.tasks;
      }
    }

    notifyListeners();
  }

  /// Visible dates state
  final List<String> _visibleDates = [];

  Future<void> updateVisibleDates(String date) async {
    if (!tasksAlreadyLoaded && !_visibleDates.contains(date)) {
      _visibleDates.add(date);

      if (_visibleDates.length > 14) {
        final lastDate = _visibleDates.last;
        _twoWeeksTasks.clear();
        _visibleDates.clear();
        _visibleDates.add(lastDate);
      } else if (_visibleDates.length == 14) {
        if (_visibleDates.contains(focusedDate.value.formatDate())) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifyListeners();
          });
        }
        if (!tasksAlreadyLoaded) {
          await loadTasksForTwoWeeks();
        }
      }
    }
  }
}
