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

  final TasksService _tasksService = getIt<TasksService>();

  /// Tasks state
  final List<UserTasks> _twoWeeksTasks = [];

  List<UserTasks> get twoWeeksTasks => _twoWeeksTasks;

  void loadTasksForTwoWeeks() async {
    final userTasks = await _tasksService.loadTasksForTwoWeeks();

    userTasks.forEach((task) {
      print('Loaded tasks for two weeks: ${task.date}');
    });
    _twoWeeksTasks.addAll(userTasks);

    notifyListeners();
  }
}
