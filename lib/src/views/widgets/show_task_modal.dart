import 'package:flutter/material.dart';

import '../task/task.view.dart';

showTaskModal(
  BuildContext context, {
  VoidCallback? buildFunction,
  VoidCallback? onCompleteFunction,
}) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        buildFunction?.call();

        return FractionallySizedBox(
          heightFactor: 0.9,
          child: TaskView(),
        );
      },
    ).whenComplete(() => onCompleteFunction?.call());
