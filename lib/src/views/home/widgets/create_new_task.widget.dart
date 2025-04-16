import 'package:flutter/material.dart';

import '../../../controllers/home/home.controller.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../localization/localization.dart';
import '../../widgets/dashed_border.widget.dart';
import '../../widgets/green_button.widget.dart';
import '../../widgets/show_task_modal.dart';

class CreateNewTask extends StatelessWidget {
  const CreateNewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.size16),
          child: DashedDivider(
            borderColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        GreenButton(
          text: t.createNew,
          onTap: () async => await showTaskModal(
            context,
            onCompleteFunction: getIt.get<HomeController>().loadUserTasks,
          ),
        ),
      ],
    );
  }
}
