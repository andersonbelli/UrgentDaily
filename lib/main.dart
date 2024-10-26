import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/controllers/settings/env_flavor.controller.dart';
import 'src/controllers/settings/settings.controller.dart';
import 'src/helpers/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvFlavorController.loadEnvironment();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  configureDependencies();

  await getIt.get<SettingsController>().loadSettings();

  runApp(MyApp());
}
