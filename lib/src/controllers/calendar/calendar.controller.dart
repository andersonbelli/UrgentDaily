import 'package:injectable/injectable.dart';

import '../../helpers/config/di.dart';
import '../../models/user_tasks.model.dart';
import '../../services/home/tasks.service.dart';
import '../base_controller.dart';

@Injectable()
class CalendarController extends BaseController {
  CalendarController() {
    loadTasksForTwoWeeks();
  }

  /// Current Date state
  late DateTime _focusedDate = DateTime.now();

  DateTime get focusedDate => _focusedDate;

  Future<void> updateFocusedDate(DateTime newFocusedDate) async {
    if (newFocusedDate == _focusedDate) return;

    _focusedDate = newFocusedDate;

    notifyListeners();
  }

  final TasksService _tasksService = getIt<TasksService>();

  /// Tasks state
  final List<UserTasks> _twoWeeksTasks = [];

  List<UserTasks> get twoWeeksTasks => _twoWeeksTasks;

  void loadTasksForTwoWeeks() async {
    final userTasks = await _tasksService.loadTasksForTwoWeeks();
    _twoWeeksTasks.addAll(userTasks);

    notifyListeners();
  }
}
