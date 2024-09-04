import 'package:flutter/material.dart';

import '../../../helpers/extensions/datetime_formatter.dart';

class HomeCalendarWidget extends StatelessWidget {
  const HomeCalendarWidget({super.key, required this.selectedDate});

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
      child: Text(
        selectedDate.formatDate(),
        style: const TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
