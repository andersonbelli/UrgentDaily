import 'package:abelliz_essentials/constants/padding.constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../controllers/settings/settings.controller.dart';
import '../../../controllers/task/task.controller.dart';
import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/extensions/datetime_formatter.dart';
import '../../../localization/localization.dart';

class CalendarPickerWidget extends StatelessWidget {
  const CalendarPickerWidget({super.key, required this.taskController});

  final TaskController taskController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final minimunDate = DateTime.utc(DateTime.now().year - 10);
        final maximunDate = DateTime.utc(DateTime.now().year + 10);

        await showDatePicker(
          context: context,
          firstDate: minimunDate,
          lastDate: maximunDate,
          locale: SettingsController.locale,
          builder: (context, _) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppPadding.kSize16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: CupertinoDatePicker(
                    onDateTimeChanged: (newDate) => taskController.selectedDate = newDate,
                    mode: CupertinoDatePickerMode.date,
                    itemExtent: 120,
                    dateOrder: DatePickerDateOrder.ymd,
                    initialDateTime: taskController.selectedDate,
                    minimumDate: minimunDate,
                    maximumDate: maximunDate,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CupertinoButton.tinted(
                          onPressed: () => Navigator.pop(context),
                          color: AppColors.RED,
                          sizeStyle: CupertinoButtonSize.medium,
                          child: Text(
                            t.cancel,
                            style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                          ),
                        ),
                        CupertinoButton.filled(
                          onPressed: () => Navigator.pop(context),
                          child: Text(t.okay),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
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
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 18),
              textAlign: TextAlign.start,
            ),
            Divider(
              color: AppColors.DARK_LIGHT.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}
