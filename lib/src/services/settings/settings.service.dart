import 'dart:io';

import 'package:flutter/material.dart';

class SettingsService {
  Future<String> preferredLanguage() async {
    /// TODO: use default locale in case no language is defined on shared_preferences
    final String defaultLocale = Platform.localeName;

    return defaultLocale.substring(0, 2);
  }

  Future<ThemeMode> themeMode() async => ThemeMode.light;

  /// TODO: Implement methods to update settings, such as theme mode and preferred language
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally
  }

  Future<void> updatePreferredLanguage(String language) async {
    // Use the shared_preferences package to persist settings locally
  }
}
