import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/controllers/settings/settings.controller.dart';
import 'src/helpers/config/di.dart';

void main() async {
  configureDependencies();

  await getIt.get<SettingsController>().loadSettings();

  runApp(MyApp());
}
