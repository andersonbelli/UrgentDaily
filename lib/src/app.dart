import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/settings/settings.controller.dart';
import 'helpers/constants/colors.constants.dart';
import 'helpers/di/di.dart';
import 'localization/localization.dart';
import 'views/auth/sign_in/sign_in.view.dart';
import 'views/calendar/calendar.view.dart';
import 'views/home/home.view.dart';
import 'views/settings/settings_view.dart';

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  final SettingsController settingsController = getIt.get<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? _) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('pt', ''),
          ],
          onGenerateTitle: (BuildContext context) => t.appTitle,
          theme: ThemeData(
            primarySwatch: AppColors.mainColor,
            colorScheme: const ColorScheme(
              primary: AppColors.mainColor,
              secondary: AppColors.PINK,
              onPrimary: AppColors.DARK,
              onSecondary: AppColors.DARK,
              onError: Colors.red,
              error: AppColors.RED,
              brightness: Brightness.light,
              surface: AppColors.CREAM,
              onSurface: AppColors.DARK_LIGHT,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.CREAM,
              centerTitle: true,
            ),
            scaffoldBackgroundColor: AppColors.CREAM,
            fontFamily: 'Open Sans',
          ),
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(
              centerTitle: true,
            ),
          ),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case CalendarView.routeName:
                    return CalendarView();
                  case HomeView.routeName:
                    return HomeView();
                  case SignInView.routeName:
                    return SignInView();
                  default:
                    return HomeView();
                }
              },
            );
          },
        );
      },
    );
  }
}
