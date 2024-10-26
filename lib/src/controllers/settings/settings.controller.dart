import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../services/settings/settings.service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    await loadEnvironment();

    _themeMode = await _settingsService.themeMode();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  loadEnvironment() async {
    try {
      await dotenv.load(fileName: _settingsService.envFlavor);
    } catch (_) {
      throw Exception('''
      Error loading environment variables!
            \nThe FILE "${_settingsService.envFlavor}" does not exist.
            Use the [sample.env] file as a reference to create a flavor:
            - dev: .env
            - stg: .env.stg
            - prod: .env.prod
            (Don't forget to reference the file in the ´pubspec.yaml´)
            ''');
    }
  }
}
