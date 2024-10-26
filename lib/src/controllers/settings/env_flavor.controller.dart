import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../helpers/constants/env_flavors.constants.dart';

class EnvFlavorController {
  static String get envFlavor {
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

  static Future<void> loadEnvironment() async {
    try {
      await dotenv.load(fileName: envFlavor);
    } catch (_) {
      throw Exception('''
      Error loading environment variables!
            \nThe FILE "$envFlavor" does not exist.
            Use the [sample.env] file as a reference to create a flavor:
            - dev: .env
            - stg: .env.stg
            - prod: .env.prod
            (Don't forget to reference the file in the ´pubspec.yaml´)
            ''');
    }
  }
}
