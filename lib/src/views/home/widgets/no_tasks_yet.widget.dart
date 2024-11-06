import 'package:flutter/material.dart';

import '../../../helpers/constants/text_sizes.constants.dart';
import '../../../localization/localization.dart';

class NoTasksYet extends StatelessWidget {
  const NoTasksYet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 450,
              child: Image.asset(
                'images/no_tasks_yet.png',
                fit: BoxFit.fitWidth,
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
