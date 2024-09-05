import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/home/home.controller.dart';
import 'controllers/settings/settings.controller.dart';
import 'helpers/constants/colors.constants.dart';
import 'services/home/tasks.service.dart';
import 'views/calendar/calendar.view.dart';
import 'views/home/home.view.dart';
import 'views/settings/settings_view.dart';

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  /// TODO: Dependency Injection (DI) here.
  final HomeController homeController = HomeController(TasksService());

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
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.CREAM,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case CalendarView.routeName:
                    return const CalendarView();
                  case HomeView.routeName:
                    return HomeView(homeController: homeController);
                  default:
                    return HomeView(homeController: homeController);
                }
              },
            );
          },
        );
      },
    );
  }
}
