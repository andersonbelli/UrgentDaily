import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/di/di.dart';
import '../../localization/localization.dart';
import '../../services/settings/settings.service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  late String _language;

  String get language => _language;

  static late Locale _locale;

  static Locale get locale => _locale;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _language = await _settingsService.preferredLanguage();

    _locale = Locale(_language);

    currentLocaleTranslation = await getIt.get<LocalizationsDelegate<AppLocalizations>>().load(Locale(_language));

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateLocalization(String newLanguage) async {
    if (newLanguage.isEmpty) return;
    if (newLanguage == _language) return;

    _language = newLanguage;
    notifyListeners();

    await _settingsService.updatePreferredLanguage(newLanguage);
  }
}
