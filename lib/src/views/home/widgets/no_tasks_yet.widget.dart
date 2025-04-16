import 'package:flutter/material.dart';

import '../../../controllers/home/home.controller.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/constants/text_sizes.constants.dart';
import '../../../localization/localization.dart';
import '../../widgets/green_button.widget.dart';
import '../../widgets/show_task_modal.dart';

class NoTasksYet extends StatelessWidget {
  const NoTasksYet(
    this.homeController, {
    super.key,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.noTasksYet,
              style: const TextStyle(
                fontSize: AppTextSize.EXTRA_LARGE,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              t.startAddingTasksNow,
              style: const TextStyle(
                fontSize: AppTextSize.MEDIUM,
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
              ),
            ),
            GreenButton(
              text: t.createTask,
              margin: const EdgeInsets.symmetric(horizontal: AppPadding.size24),
              onTap: () async => await showTaskModal(
                context,
                onCompleteFunction: homeController.loadUserTasks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
