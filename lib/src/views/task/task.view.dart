import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/task/task.controller.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/constants/padding.constants.dart';
import '../../helpers/constants/text_sizes.constants.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../widgets/dashed_border.widget.dart';
import '../widgets/green_button.widget.dart';
import 'widgets/calendar_picker.widget.dart';

class TaskView extends StatelessWidget {
  const TaskView({
    super.key,
    required this.taskController,
  });

  final TaskController taskController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppPadding.SMALL,
              horizontal: AppPadding.MEDIUM,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'New task',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTextSize.LARGE,
                      ),
                    ),
                  ),
                  TaskFieldWithTitle(
                    title: 'title',
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Task 1 - Sep 5',
                        hintStyle: TextStyle(
                          color: AppColors.GRAY,
                        ),
                      ),
                      controller: taskController.title,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  TaskFieldWithTitle(
                    title: 'date',
                    child: SizedBox(
                      width: double.infinity,
                      child: CalendarPickerWidget(
                        selectedDate: DateTime.now(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: taskController.isRecursive,
                        onChanged: (value) {
                          taskController.toggleRecursive(recursive: value);
                        },
                        checkColor: AppColors.DARK,
                        activeColor: AppColors.GREEN,
                      ),
                      GestureDetector(
                        onTap: () {
                          taskController.toggleRecursive();
                        },
                        child: const Text(
                          'recursive task?',
                          style: TextStyle(
                            fontSize: AppTextSize.MEDIUM,
                            color: AppColors.GRAY,
                            fontWeight: FontWeight.w100,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Visibility(
                    visible: taskController.isRecursive,
                    child: DaysOfWeekRow(
                      onSelectedDaysOfWeek: taskController.selectRecursiveDay,
                      selectedDays: taskController.selectedDaysOfWeek,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'priority',
                        style: TextStyle(
                          fontSize: AppTextSize.MEDIUM,
                          color: AppColors.GRAY,
                          fontWeight: FontWeight.w100,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      RadioPriority(
                        title: 'urgent',
                        groupPriority: taskController.taskPriority,
                        priority: TaskPriority.URGENT,
                        selectedPriority: taskController.selectTaskPriority,
                      ),
                      RadioPriority(
                        title: 'important',
                        groupPriority: taskController.taskPriority,
                        priority: TaskPriority.IMPORTANT,
                        selectedPriority: taskController.selectTaskPriority,
                      ),
                      RadioPriority(
                        title: 'important, not urgent',
                        groupPriority: taskController.taskPriority,
                        priority: TaskPriority.IMPORTANT_NOT_URGENT,
                        selectedPriority: taskController.selectTaskPriority,
                      ),
                      RadioPriority(
                        title: 'not urgent',
                        groupPriority: taskController.taskPriority,
                        priority: TaskPriority.NOT_IMPORTANT,
                        selectedPriority: taskController.selectTaskPriority,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        GreenButton(text: 'CREATE TASK', onTap: () => print('Task created')),
      ],
    );
  }
}

class TaskFieldWithTitle extends StatelessWidget {
  const TaskFieldWithTitle({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppTextSize.MEDIUM,
            color: AppColors.GRAY,
            fontWeight: FontWeight.w100,
            fontStyle: FontStyle.italic,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: child,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class RadioPriority extends StatelessWidget {
  const RadioPriority({
    super.key,
    required this.title,
    required this.groupPriority,
    required this.priority,
    required this.selectedPriority,
  });

  final String title;
  final TaskPriority groupPriority;
  final TaskPriority priority;
  final ValueChanged<TaskPriority?> selectedPriority;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectedPriority(priority),
      child: Row(
        children: [
          CupertinoRadio(
            activeColor: AppColors.DARK,
            value: priority,
            groupValue: groupPriority,
            onChanged: (value) => selectedPriority(value),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.SMALL),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: AppPadding.MEDIUM,
              ),
              child: DashedDivider(
                dashLength: 6,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: priority.color.withOpacity(0.3),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.MEDIUM,
                    vertical: AppPadding.SMALL,
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DaysOfWeekRow extends StatelessWidget {
  final Function(RecursiveDay day, bool selected) onSelectedDaysOfWeek;
  final Map<RecursiveDay, bool> selectedDays;

  const DaysOfWeekRow({
    super.key,
    required this.onSelectedDaysOfWeek,
    required this.selectedDays,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DaysOfWeekItem(
          dayOfWeek: 'Sun',
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.SUN, value);
          },
          selected: selectedDays[RecursiveDay.SUN] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: 'Mon',
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.MON, value);
          },
          selected: selectedDays[RecursiveDay.MON] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: 'Tue',
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.TUE, value);
          },
          selected: selectedDays[RecursiveDay.TUE] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: 'Wed',
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.WED, value);
          },
          selected: selectedDays[RecursiveDay.WED] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: 'Thu',
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.THU, value);
          },
          selected: selectedDays[RecursiveDay.THU] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: 'Fri',
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.FRI, value);
          },
          selected: selectedDays[RecursiveDay.FRI] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: 'Sat',
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.SAT, value);
          },
          selected: selectedDays[RecursiveDay.SAT] == true,
        ),
      ],
    );
  }
}

class DaysOfWeekItem extends StatelessWidget {
  final String dayOfWeek;
  final ValueChanged<bool> daySelected;
  final bool selected;

  const DaysOfWeekItem({
    super.key,
    required this.dayOfWeek,
    required this.daySelected,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      shape: const CircleBorder(),
      showCheckmark: false,
      color: selected
          ? WidgetStateProperty.all(AppColors.DARK)
          : WidgetStateProperty.all(Colors.transparent),
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          dayOfWeek,
          style: TextStyle(
            color: selected ? AppColors.GREEN : AppColors.DARK,
          ),
        ),
      ),
      selected: selected,
      onSelected: daySelected,
    );
  }
}
