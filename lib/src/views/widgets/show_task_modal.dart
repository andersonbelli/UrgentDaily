import 'package:flutter/material.dart';

import '../../controllers/task/task.controller.dart';
import '../../helpers/di/di.dart';
import '../../models/task.model.dart';
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
    ).then((value) {
      final modalTask = value as Task?;
      if (modalTask != null) {
        final controller = getIt.get<TaskController>();
        controller.taskData(modalTask);

        if (modalTask.id != null) {
          controller.createTask();
        } else {
          controller.editTask();
        }
      }
    }).whenComplete(() => onCompleteFunction?.call());
