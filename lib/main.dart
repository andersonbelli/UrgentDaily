import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/controllers/settings/env_flavor.controller.dart';
import 'src/controllers/settings/settings.controller.dart';
import 'src/helpers/di/di.dart';
import 'src/services/auth/auth.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvFlavorController.loadEnvironment();

  await Firebase.initializeApp(
    name: 'UrgentDaily',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  configureDependencies();

  await getIt.get<SettingsController>().loadSettings();

  // TODO: Move anonymous sign-in to SplashScreen loading
  await getIt.get<AuthService>().signInAnonymously();

  runApp(MyApp());
}
