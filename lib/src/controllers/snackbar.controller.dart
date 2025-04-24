import 'package:abelliz_essentials/constants/colors.constants.dart';
import 'package:flutter/material.dart';

import '../localization/localization.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class SnackbarController {
  void showSnackbar({String? message, SnackBar? snackBar}) => AppSnackbar(
        scaffoldMessengerKey,
        message: message,
        appSnackBar: snackBar,
      );
}

class AppSnackbar {
  AppSnackbar(
    GlobalKey<ScaffoldMessengerState> key, {
    String? message,
    SnackBar? appSnackBar,
  })  : assert(
          message == null && appSnackBar == null,
          'Either message or appSnackBar must be provided.',
        ),
        assert(
          message != null && appSnackBar != null,
          'Either message or appSnackBar must be provided, not both',
        ) {
    if (message != null) {
      key.currentState?.showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else if (appSnackBar != null) {
      key.currentState?.showSnackBar(appSnackBar);
    }
  }

  static SnackBar defaultSnackBar({
    required String message,
    required VoidCallback onPressed,
  }) {
    return SnackBar(
      content: Text(message),
      backgroundColor: AppColors.GREEN,
      action: SnackBarAction(
        label: t.done,
        textColor: AppColors.GREEN,
        onPressed: onPressed,
      ),
    );
  }
}
