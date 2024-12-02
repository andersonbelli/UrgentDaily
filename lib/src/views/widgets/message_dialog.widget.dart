import 'package:flutter/material.dart';

import '../../localization/localization.dart';

void showMessageDialog(
  BuildContext context,
  String message, {
  String? title,
  String? buttonText,
  VoidCallback? buttonAction,
}) =>
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? t.errorTitle),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: buttonAction ?? () => Navigator.of(ctx).pop(),
            child: Text(buttonText ?? t.errorOkButton),
          ),
        ],
      ),
    );
