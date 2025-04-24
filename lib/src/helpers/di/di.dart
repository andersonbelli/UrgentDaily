import 'package:auto_injector/auto_injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../controllers/auth/sign_in.controller.dart';
import '../../controllers/auth/sign_up.controller.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/calendar/calendar.controller.dart';
import '../../controllers/home/home.controller.dart';
import '../../controllers/settings/settings.controller.dart';
import '../../controllers/snackbar.controller.dart';
import '../../controllers/task/task.controller.dart';
import '../../services/auth/auth.local.service.dart';
import '../../services/auth/auth.remote.service.dart';
import '../../services/settings.local.service.dart';
import '../../services/tasks/tasks.service.dart';

final getIt = AutoInjector();

Future<void> configureDependencies() async {
  getIt.addSingleton(() => AppLocalizations.delegate);
  getIt.addSingleton(SnackbarController.new);

  // Local Storage
  getIt.addSingleton(FlutterSecureStorage.new);

  // Settings
  getIt.addSingleton(SettingsService.new);
  getIt.addSingleton(SettingsController.new);

  // Register Firebase services
  getIt.addSingleton(() => FirebaseAuth.instance);
  getIt.addSingleton(() => FirebaseFirestore.instance);

  // Services
  getIt.addSingleton(AuthLocalService.new);
  getIt.addSingleton(AuthRemoteService.new);
  getIt.add(TasksService.new);

  // Controllers
  getIt.addSingleton(BaseController.new);
  getIt.addSingleton(TaskController.new);
  getIt.addSingleton(HomeController.new);
  getIt.addSingleton(CalendarController.new);
  getIt.addSingleton(SignInController.new);
  getIt.addSingleton(SignUpController.new);

  // Inform that you have finished adding instances
  getIt.commit();
}
