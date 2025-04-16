import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'flavors.dart';
import 'src/app.dart';
import 'src/controllers/settings/env_flavor.controller.dart';
import 'src/controllers/settings/settings.controller.dart';
import 'src/helpers/di/di.dart';
import 'src/services/auth/auth.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvFlavorController.loadEnvironment();

  await Firebase.initializeApp(
    name: F.title,
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  configureDependencies();

  await getIt.get<SettingsController>().loadSettings();

  try {
    await getIt.get<AuthService>().signInAnonymously().timeout(const Duration(seconds: 10));
  } catch (e) {
    debugPrint('❌ Anonymous sign-in failed or timed out: $e');
  }

  runApp(MyApp());
}
