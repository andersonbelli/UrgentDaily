import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../flavors.dart';
import 'controllers/settings/settings.controller.dart';
import 'controllers/snackbar.controller.dart';
import 'helpers/constants/colors.constants.dart';
import 'helpers/di/di.dart';
import 'localization/localization.dart';
import 'views/auth/sign_in/sign_in.view.dart';
import 'views/auth/sign_up/sign_up.view.dart';
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
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
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
                Widget route = const HomeView();

                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    route = SettingsView(controller: settingsController);
                  case CalendarView.routeName:
                    route = CalendarView();
                  case HomeView.routeName:
                    route = const HomeView();
                  case SignInView.routeName:
                    route = SignInView();
                  case SignUpView.routeName:
                    route = SignUpView();
                  default:
                    route = const HomeView();
                }

                return _flavorBanner(child: route);
              },
            );
          },
        );
      },
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) =>
      show
          ? Banner(
              location: BannerLocation.topStart,
              message: F.name,
              color: Colors.red.withValues(alpha: .6),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                letterSpacing: 1.0,
              ),
              textDirection: TextDirection.ltr,
              child: child,
            )
          : Container(
              child: child,
            );
}
