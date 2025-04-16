import 'package:flutter/material.dart';

import '../../helpers/constants/colors.constants.dart';
import '../../localization/localization.dart';

void showMessageDialog(
  BuildContext context,
  String message, {
  String? title,
  String? buttonText,
  VoidCallback? buttonAction,
  bool showCancelButton = false,
}) =>
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? t.errorTitle),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: buttonAction ?? () => Navigator.of(ctx).pop(),
            child: Text(buttonText ?? t.okay),
          ),
          if (showCancelButton)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                t.cancel,
                style: const TextStyle(color: AppColors.RED),
              ),
            ),
        ],
      ),
    );
