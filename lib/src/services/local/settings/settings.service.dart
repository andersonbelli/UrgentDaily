import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../helpers/di/di.dart';
import '../local_keys.dart';

class SettingsService {
  final storage = getIt.get<FlutterSecureStorage>();

  Future<String> getPreferredLanguage() async {
    final preferedLocale = await storage.read(key: LocalKeys.localeKey);

    final String defaultLocale = preferedLocale ?? Platform.localeName;

    return defaultLocale.substring(0, 2);
  }

  Future<void> updatePreferredLanguage(String localeName) async {
    await storage.write(
      key: LocalKeys.localeKey,
      value: localeName,
    );
  }

  Future<ThemeMode> themeMode() async => ThemeMode.light;

  Future<void> updateThemeMode(ThemeMode theme) async {
    await storage.write(
      key: LocalKeys.themeKey,
      value: theme.name,
    );
  }
}
