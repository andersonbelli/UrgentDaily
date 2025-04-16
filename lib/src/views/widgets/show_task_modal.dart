import 'package:flutter/material.dart';

import '../../controllers/home/home.controller.dart';
import '../../helpers/di/di.dart';
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
          child: TaskView(date: getIt.get<HomeController>().selectedDate),
        );
      },
    ).whenComplete(() => onCompleteFunction?.call());
