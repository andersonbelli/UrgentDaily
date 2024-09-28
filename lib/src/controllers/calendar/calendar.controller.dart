import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../helpers/config/di.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../../models/task.model.dart';
import '../../models/user_tasks.model.dart';
import '../../services/home/tasks.service.dart';
import '../base_controller.dart';

@Injectable()
class CalendarController extends BaseController {
  CalendarController();

  final TasksService _tasksService = getIt<TasksService>();

  /// Current Date state
  late DateTime _focusedDate = DateTime.now();

  DateTime get focusedDate => _focusedDate;

  Future<void> updateFocusedDate(DateTime newFocusedDate) async {
    if (newFocusedDate == _focusedDate) return;

    _focusedDate = newFocusedDate;

    updateTasksOfSelectedDay();
  }

  /// Tasks state
  final List<UserTasks> _twoWeeksTasks = [];

  List<UserTasks> get twoWeeksTasks => _twoWeeksTasks;
  bool tasksAlreadyLoaded = false;

  void loadTasksForTwoWeeks() async {
    final userTasks = await _tasksService.loadTasksForTwoWeeks(
      _visibleDates.first.convertStringToDateTime(),
      _visibleDates.last.convertStringToDateTime(),
    );

    _twoWeeksTasks.addAll(userTasks);
    for (final task in _twoWeeksTasks) {
      task.tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    }

    if (!tasksAlreadyLoaded) {
      tasksAlreadyLoaded = true;
    }
  }

  /// Tasks of selected day state
  late List<Task> _tasksOfSelectedDay = [];

  List<Task> get tasksOfSelectedDay => _tasksOfSelectedDay;

  updateTasksOfSelectedDay() async {
    _tasksOfSelectedDay = [];

    final tasksForSelectedDay = _twoWeeksTasks.where(
      (task) => task.date.formatDate() == _focusedDate.formatDate(),
    );

    if (tasksForSelectedDay.isNotEmpty) {
      _tasksOfSelectedDay = tasksForSelectedDay.first.tasks;
    }
    notifyListeners();
  }

  /// Visible dates state
  final List<String> _visibleDates = [];

  updateVisibleDates(String date) {
    if (!tasksAlreadyLoaded && !_visibleDates.contains(date)) {
      _visibleDates.add(date);

      if (_visibleDates.length > 14) {
        final lastDate = _visibleDates.last;
        _twoWeeksTasks.clear();
        _visibleDates.clear();
        _visibleDates.add(lastDate);
      } else if (_visibleDates.length == 14) {
        if (_visibleDates.contains(_focusedDate.formatDate())) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifyListeners();
          });
        }
        if (!tasksAlreadyLoaded) {
          loadTasksForTwoWeeks();
        }
      }
    }
  }
}
