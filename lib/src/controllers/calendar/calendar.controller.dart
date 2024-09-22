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

    _selectedDayIsOnVisibleDates();
  }

  /// Tasks state
  final List<UserTasks> _twoWeeksTasks = [];

  List<UserTasks> get twoWeeksTasks => _twoWeeksTasks;

  void loadTasksForTwoWeeks() async {
    if (!_visibleDatesIsReady) return;

    final userTasks = await _tasksService.loadTasksForTwoWeeks(
      _visibleDates.first.convertStringToDateTime(),
      _visibleDates.last.convertStringToDateTime(),
    );

    _twoWeeksTasks.addAll(userTasks);

    updateTasksOfSelectedDay();
  }

  /// Tasks of selected day state
  late List<Task> _tasksOfSelectedDay = [];

  List<Task> get tasksOfSelectedDay => _tasksOfSelectedDay;

  updateTasksOfSelectedDay() async {
    final tasksForSelectedDay = _twoWeeksTasks
        .where((task) => task.date.formatDate() == _focusedDate.formatDate());

    if (tasksForSelectedDay.isNotEmpty) {
      _tasksOfSelectedDay = tasksForSelectedDay.first.tasks;
    }

    notifyListeners();
  }

  /// Visible dates state
  final List<String> _visibleDates = [];

  bool _visibleDatesIsReady = false;

  updateVisibleDates(String date) {
    _visibleDates.add(date);
    if (_visibleDates.length == 14) {
      _visibleDatesIsReady = true;
      if (_visibleDates.contains(_focusedDate.formatDate()) &&
          _twoWeeksTasks.isEmpty) {
        loadTasksForTwoWeeks();
      }
    } else {
      if (_visibleDates.length > 14) {
        final lastDate = _visibleDates.last;
        _visibleDates.clear();
        _visibleDates.add(lastDate);
      }
      _visibleDatesIsReady = false;
    }
  }

  _selectedDayIsOnVisibleDates() {
    if (_visibleDates.contains(_focusedDate.formatDate())) {
      updateTasksOfSelectedDay();
    } else {
      loadTasksForTwoWeeks();
    }
  }
}
