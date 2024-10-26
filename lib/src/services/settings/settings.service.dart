import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/constants/env_flavors.constants.dart';

class SettingsService {
  String get envFlavor {
    String? flavor = 'dev';
    if (appFlavor != null && envFlavors.containsKey(appFlavor)) {
      flavor = appFlavor;
    } else {
      log('''
      \nFlavor not defined: <$appFlavor>
      Use the flag --flavor=<dev|stg|prod> to set the flavor.
      ''');
    }
    return envFlavors[flavor]!;
  }

  Future<ThemeMode> themeMode() async => ThemeMode.light;

  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }
}
