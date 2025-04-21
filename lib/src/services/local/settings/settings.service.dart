import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../helpers/di/di.dart';
import '../local_storage_keys.dart';

class SettingsService {
  final storage = getIt.get<FlutterSecureStorage>();

  Future<String> getPreferredLanguage() async {
    final preferedLocale = await storage.read(key: LocalStorageKeys.localeKey);

    final String defaultLocale = preferedLocale ?? Platform.localeName;

    return defaultLocale.substring(0, 2);
  }

  Future<void> updatePreferredLanguage(String localeName) async {
    await storage.write(
      key: LocalStorageKeys.localeKey,
      value: localeName,
    );
  }

  Future<ThemeMode> themeMode() async => ThemeMode.light;

  Future<void> updateThemeMode(ThemeMode theme) async {
    await storage.write(
      key: LocalStorageKeys.themeKey,
      value: theme.name,
    );
  }
}
