import 'package:flutter/material.dart';

import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/enums/priority.enum.dart';

class CalendarTaskItem extends StatelessWidget {
  const CalendarTaskItem({
    super.key,
    required this.title,
    required this.priority,
    this.isCompleted = false,
  });

  final String title;
  final TaskPriority priority;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.SMALL,
        vertical: AppPadding.SMALL / 2,
      ),
      child: ListTile(
        dense: true,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.DARK,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        style: ListTileStyle.drawer,
        textColor: AppColors.DARK,
        tileColor: priority.color.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: AppColors.GRAY,
          ),
        ),
        trailing: Badge(
          label: const Text('completed'),
          backgroundColor: AppColors.GREEN,
          textColor: AppColors.DARK,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.SMALL,
            vertical: AppPadding.SMALL / 2,
          ),
          isLabelVisible: isCompleted,
        ),
      ),
    );
  }
}