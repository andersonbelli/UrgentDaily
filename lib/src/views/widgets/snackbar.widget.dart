import 'package:flutter/material.dart';

showSnackBar(BuildContext context, SnackBar appSnackBar) => ScaffoldMessenger.of(context).showSnackBar(
      appSnackBar,
    );

appSnackBar({
  required String message,
  Color? backgroundColor,
  SnackBarAction? action,
  bool showCloseIcon = false,
}) =>
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      action: action,
      showCloseIcon: showCloseIcon,
    );
