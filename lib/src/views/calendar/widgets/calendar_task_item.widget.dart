import 'package:flutter/material.dart';

import '../../../controllers/task/task.controller.dart';
import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../helpers/enums/priority.enum.dart';
import '../../../models/task.model.dart';
import '../../widgets/show_task_modal.dart';

class CalendarTaskItem extends StatelessWidget {
  const CalendarTaskItem({
    super.key,
    required this.task,
    required this.title,
    required this.priority,
    this.isCompleted = false,
  });

  final Task task;
  final String title;
  final TaskPriority priority;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.size8,
        vertical: AppPadding.size8 / 2,
      ),
      child: ListTile(
        onTap: () async => await showTaskModal(
          context,
          buildFunction: () => getIt<TaskController>().taskData(task: task),
        ),
        dense: true,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.DARK,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        style: ListTileStyle.drawer,
        textColor: AppColors.DARK,
        tileColor: priority.color.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: AppColors.GRAY,
          ),
        ),
        trailing: Badge(
          label: const Text('completed'),
          backgroundColor: AppColors.GREEN,
          textColor: AppColors.DARK,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.size8,
            vertical: AppPadding.size8 / 2,
          ),
          isLabelVisible: isCompleted,
        ),
      ),
    );
  }
}
