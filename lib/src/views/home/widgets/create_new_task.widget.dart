import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/task/task.controller.dart';
import '../../task/task.view.dart';
import '../../widgets/dashed_border.widget.dart';
import '../../widgets/green_button.widget.dart';

class CreateNewTask extends StatelessWidget {
  const CreateNewTask({super.key, required this.taskController});

  final TaskController taskController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashedDivider(),
        GreenButton(
          text: AppLocalizations.of(context)!.createNew,
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child: ListenableBuilder(
                listenable: taskController,
                builder: (context, _) => TaskView(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
