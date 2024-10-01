import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/task/task.controller.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/di/di.dart';
import '../../task/task.view.dart';
import '../../widgets/dashed_border.widget.dart';
import '../../widgets/green_button.widget.dart';

class CreateNewTask extends StatelessWidget {
  CreateNewTask({super.key});

  final TaskController taskController = getIt<TaskController>();

  static showNewTaskModal(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.9,
          child: TaskView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.MEDIUM),
          child: DashedDivider(
            borderColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        GreenButton(
          text: AppLocalizations.of(context)!.createNew,
          onTap: () => showNewTaskModal(context),
        ),
      ],
    );
  }
}
