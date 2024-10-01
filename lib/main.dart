import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/controllers/settings/settings.controller.dart';
import 'src/helpers/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  await getIt.get<SettingsController>().loadSettings();

  runApp(MyApp());
}
