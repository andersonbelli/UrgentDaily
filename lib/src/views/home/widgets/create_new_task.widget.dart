import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers/constants/padding.constants.dart';
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
          padding: const EdgeInsets.symmetric(vertical: AppPadding.MEDIUM),
          child: DashedDivider(
            borderColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        GreenButton(
          text: AppLocalizations.of(context)!.createNew,
          onTap: () async => await showTaskModal(context),
        ),
      ],
    );
  }
}
