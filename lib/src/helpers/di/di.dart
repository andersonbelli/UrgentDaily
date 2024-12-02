import 'package:auto_injector/auto_injector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/auth/sign_in.controller.dart';
import '../../controllers/auth/sign_up.controller.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/calendar/calendar.controller.dart';
import '../../controllers/home/home.controller.dart';
import '../../controllers/settings/settings.controller.dart';
import '../../controllers/task/task.controller.dart';
import '../../services/auth/auth.service.dart';
import '../../services/home/tasks.service.dart';
import '../../services/settings/settings.service.dart';

final getIt = AutoInjector();

void configureDependencies() async {
  getIt.addSingleton(() => AppLocalizations.delegate);

  // Register Firebase services
  getIt.addSingleton(() => FirebaseAuth.instance);

  // Services
  getIt.add(TasksService.new);
  getIt.addSingleton(AuthService.new);

  // Controllers
  getIt.addSingleton(BaseController.new);
  getIt.addSingleton(TaskController.new);
  getIt.addSingleton(HomeController.new);
  getIt.addSingleton(CalendarController.new);
  getIt.addSingleton(SignInController.new);
  getIt.addSingleton(SignUpController.new);

  // Settings
  getIt.addSingleton(SettingsService.new);
  getIt.addSingleton(SettingsController.new);

  // Inform that you have finished adding instances
  getIt.commit();
}
