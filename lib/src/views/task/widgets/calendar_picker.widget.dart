import 'package:flutter/material.dart';

import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/extensions/datetime_formatter.dart';

class CalendarPickerWidget extends StatelessWidget {
  const CalendarPickerWidget({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDatePicker(
        context: context,
        builder: (BuildContext context, widget) {
          return DatePickerDialog(
            firstDate: DateTime.now(),
            lastDate: DateTime.utc(2030),
            currentDate: selectedDate,
          );
        },
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2030),
      ),
      child: Container(
        width: double.infinity,
        color: AppColors.CREAM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              selectedDate.formatDate(),
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
