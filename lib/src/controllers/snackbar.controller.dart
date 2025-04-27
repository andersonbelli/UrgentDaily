import 'package:abelliz_essentials/constants/colors.constants.dart';
import 'package:flutter/material.dart';

import '../localization/localization.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class SnackbarController {
  void showSnackbar({String? message, SnackBar? snackBar}) {
    if (message == null && snackBar == null) {
      throw 'No message set';
    }

    AppSnackbar(
      scaffoldMessengerKey,
      message: message,
      appSnackBar: snackBar,
    );
  }
}

class AppSnackbar {
  AppSnackbar(
    GlobalKey<ScaffoldMessengerState> key, {
    String? message,
    SnackBar? appSnackBar,
  }) {
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
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.GREEN,
        ),
      ),
      // backgroundColor: AppColors.GREEN,
      action: SnackBarAction(
        label: t.done,
        textColor: AppColors.GREEN,
        onPressed: onPressed,
      ),
    );
  }
}
