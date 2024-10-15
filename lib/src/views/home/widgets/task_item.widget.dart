import 'package:flutter/material.dart';

import '../../../controllers/home/home.controller.dart';
import '../../../controllers/task/task.controller.dart';
import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../models/task.model.dart';
import '../../widgets/show_task_modal.dart';

class TaskItem extends StatelessWidget {
  TaskItem({
    super.key,
    required this.task,
  });

  final Task task;
  final HomeController homeController = getIt<HomeController>();
  final TaskController taskController = getIt<TaskController>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      onTap: () => homeController.toggleCompletedTask(
        task,
        !task.isCompleted,
      ),
      leading: IconButton(
        onPressed: () async => await showTaskModal(
          context,
          buildFunction: () => taskController.taskData(
            task,
          ),
        ),
        icon: const Icon(
          Icons.edit,
        ),
      ),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: (isTaskCompleted) => homeController.toggleCompletedTask(
          task,
          isTaskCompleted,
        ),
        checkColor: AppColors.DARK,
        activeColor: AppColors.GREEN,
      ),
    );
  }
}
