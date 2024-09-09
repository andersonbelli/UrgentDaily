import 'package:flutter/material.dart';

import '../../../controllers/task/task.controller.dart';
import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/extensions/datetime_formatter.dart';

class CalendarPickerWidget extends StatelessWidget {
  const CalendarPickerWidget({super.key, required this.taskController});

  final TaskController taskController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final newDateSelected = await showDatePicker(
          context: context,
          builder: (BuildContext context, widget) {
            return DatePickerDialog(
              firstDate: DateTime.now(),
              lastDate: DateTime.utc(2030),
              currentDate: taskController.selectedDate,
            );
          },
          firstDate: DateTime.now(),
          lastDate: DateTime.utc(2030),
        );

        if (newDateSelected != null) {
          taskController.selectDate(newDateSelected);
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              taskController.selectedDate.formatDate(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 18),
              textAlign: TextAlign.start,
            ),
            Divider(
              color: AppColors.DARK_LIGHT.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}
