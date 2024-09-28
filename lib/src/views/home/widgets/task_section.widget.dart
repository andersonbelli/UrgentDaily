import 'package:flutter/material.dart';

import '../../../controllers/home/home.controller.dart';
import '../../../controllers/task/task.controller.dart';
import '../../../helpers/config/di.dart';
import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../models/task.model.dart';
import 'task_item.widget.dart';

class TaskSection extends StatelessWidget {
  const TaskSection({
    super.key,
    required this.title,
    required this.color,
    required this.tasks,
  });

  final String title;
  final Color color;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.MEDIUM,
        vertical: AppPadding.SMALL,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.MEDIUM),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.GRAY.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppPadding.SMALL,
              horizontal: AppPadding.LARGE,
            ),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.DARK.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.DARK,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: AppPadding.MEDIUM,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskItem(
                task: tasks[index],
                homeController: getIt<HomeController>(),
                taskController: getIt<TaskController>(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
