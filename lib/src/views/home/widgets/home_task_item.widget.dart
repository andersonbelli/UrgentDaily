import 'package:flutter/material.dart';

import '../../../controllers/home/home.controller.dart';
import '../../../controllers/snackbar.controller.dart';
import '../../../controllers/task/task.controller.dart';
import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../localization/localization.dart';
import '../../../models/task.model.dart';
import '../../widgets/message_dialog.widget.dart';
import '../../widgets/show_task_modal.dart';

class HomeTaskItem extends StatelessWidget {
  HomeTaskItem({
    super.key,
    required this.index,
    required this.task,
  });

  final int index;
  final Task task;
  final HomeController homeController = getIt<HomeController>();
  final TaskController taskController = getIt<TaskController>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ValueNotifier(homeController.isEditMode),
      builder: (context, isEditMode, _) {
        return ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          onTap: isEditMode
              ? context.mounted
                  ? () => getIt.get<SnackbarController>().showSnackbar(
                        snackBar: AppSnackbar.defaultSnackBar(
                          message: t.doneEditingTasks,
                          onPressed: () {
                            if (homeController.isEditMode) {
                              homeController.toggleEditMode();
                            }
                          },
                        ),
                      )
                  : null
              : () => homeController.toggleCompletedTask(
                    task,
                    !task.isCompleted,
                  ),
          leading: Text(
            '${index.toString()}.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          contentPadding: EdgeInsets.zero,
          trailing: isEditMode
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: IconButton(
                        onPressed: () async => showMessageDialog(
                          context,
                          t.actionCantBeUndone,
                          title: t.confirmDelete,
                          buttonText: t.confirm,
                          buttonAction: () {
                            homeController.removeTask(task);
                            Navigator.pop(context);
                          },
                          showCancelButton: true,
                        ),
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        onPressed: () async => await showTaskModal(
                          context,
                          buildFunction: () => taskController.taskData(
                            task: task,
                          ),
                          onCompleteFunction: () {
                            homeController.loadUserTasks();
                            homeController.toggleEditMode();
                          },
                        ),
                        icon: const Icon(
                          Icons.edit,
                        ),
                      ),
                    ),
                  ],
                )
              : Checkbox(
                  value: task.isCompleted,
                  onChanged: (isTaskCompleted) => homeController.toggleCompletedTask(
                    task,
                    isTaskCompleted,
                  ),
                  checkColor: AppColors.DARK,
                  activeColor: AppColors.GREEN,
                ),
        );
      },
    );
  }
}
