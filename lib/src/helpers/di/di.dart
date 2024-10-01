import 'package:auto_injector/auto_injector.dart';

import '../../controllers/calendar/calendar.controller.dart';
import '../../controllers/home/home.controller.dart';
import '../../controllers/settings/settings.controller.dart';
import '../../controllers/task/task.controller.dart';
import '../../services/home/tasks.service.dart';
import '../../services/settings/settings.service.dart';

final getIt = AutoInjector();

configureDependencies() async {
  // Services
  getIt.add(TasksService.new);

  // Controllers
  getIt.addSingleton(TaskController.new);
  getIt.add(HomeController.new);
  getIt.add(CalendarController.new);

  // Settings
  getIt.addSingleton(SettingsService.new);
  getIt.addSingleton(SettingsController.new);

  // Inform that you have finished adding instances
  getIt.commit();
}
