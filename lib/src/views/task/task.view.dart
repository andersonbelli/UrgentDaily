import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/task/task.controller.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/constants/padding.constants.dart';
import '../../helpers/constants/text_sizes.constants.dart';
import '../../helpers/di/di.dart';
import '../../helpers/enums/error_fields/task_error_fields.enum.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../../localization/localization.dart';
import '../widgets/dashed_border.widget.dart';
import '../widgets/error_messages_container.widget.dart';
import '../widgets/green_button.widget.dart';
import '../widgets/text_field_with_title.widget.dart';
import '../widgets/text_shadow.widget.dart';
import 'widgets/calendar_picker.widget.dart';

class TaskView extends StatefulWidget {
  TaskView({super.key});

  final TaskController taskController = getIt<TaskController>();

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.taskController;

    return ListenableBuilder(
      listenable: widget.taskController,
      builder: (context, child) {
        return Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.SMALL,
                  horizontal: AppPadding.MEDIUM,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        dense: true,
                        trailing: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.inverseSurface,
                            shadows: [
                              BoxShadow(
                                color: AppColors.DARK.withOpacity(0.3),
                                blurRadius: 0.4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: TextShadow(
                          text: controller.taskId == null
                              ? t.newTask
                              : controller.originalTitle,
                          shadowOpacity: 0.5,
                        ),
                      ),
                      TaskFieldWithTitle(
                        title: t.title,
                        child: TextFieldWithTitle(
                          hintText: t.whatAreYouPlanning,
                          hasError: controller.validationErrorMessages
                              .containsKey(TaskErrorFieldsEnum.TITLE),
                          errorText: controller.validationErrorMessages
                                  .containsKey(TaskErrorFieldsEnum.TITLE)
                              ? controller.validationErrorMessages[
                                      TaskErrorFieldsEnum.TITLE] ??
                                  ''
                              : '',
                          controller: controller.title,
                          onChanged: (value) {
                            controller.title.clearComposing();
                            if (value.trim().isNotEmpty &&
                                controller.validationErrorMessages
                                    .containsKey(TaskErrorFieldsEnum.TITLE)) {
                              controller.removeValidationError(
                                TaskErrorFieldsEnum.TITLE,
                              );
                            } else {
                              controller.validateFields();
                            }
                          },
                        ),
                      ),
                      TaskFieldWithTitle(
                        title: t.date,
                        child: SizedBox(
                          width: double.infinity,
                          child: CalendarPickerWidget(
                            taskController: controller,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: controller.isRecursive,
                            onChanged: (value) =>
                                controller.toggleRecursive(recursive: value),
                            checkColor: AppColors.DARK,
                            activeColor: AppColors.GREEN,
                          ),
                          GestureDetector(
                            onTap: () => controller.toggleRecursive(),
                            child: Text(
                              t.recursiveTask,
                              style: TextStyle(
                                fontSize: AppTextSize.MEDIUM,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Visibility(
                        visible: controller.isRecursive,
                        child: DaysOfWeekRow(
                          onSelectedDaysOfWeek: controller.selectRecursiveDay,
                          selectedDays: controller.selectedDaysOfWeek,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.priority,
                            style: TextStyle(
                              fontSize: AppTextSize.MEDIUM,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          RadioPriority(
                            title: t.urgent.toLowerCase(),
                            groupPriority: controller.taskPriority,
                            priority: TaskPriority.URGENT,
                            selectedPriority: controller.selectTaskPriority,
                          ),
                          RadioPriority(
                            title: t.important.toLowerCase(),
                            groupPriority: controller.taskPriority,
                            priority: TaskPriority.IMPORTANT,
                            selectedPriority: controller.selectTaskPriority,
                          ),
                          RadioPriority(
                            title: t.importantNotUrgent.toLowerCase(),
                            groupPriority: controller.taskPriority,
                            priority: TaskPriority.IMPORTANT_NOT_URGENT,
                            selectedPriority: controller.selectTaskPriority,
                          ),
                          RadioPriority(
                            title: t.notImportant.toLowerCase(),
                            groupPriority: controller.taskPriority,
                            priority: TaskPriority.NOT_IMPORTANT,
                            selectedPriority: controller.selectTaskPriority,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ErrorMessagesContainer(
              isVisible: controller.validationErrorMessages.isNotEmpty,
              errorMessagesList: controller.validationErrorMessages,
            ),
            child!,
          ],
        );
      },
      child: GreenButton(
        text: widget.taskController.taskId == null ? t.createTask : t.editTask,
        isDisabled: controller.validationErrorMessages.isNotEmpty,
        onTap: () {
          widget.taskController.validateFields();

          if (widget.taskController.validationErrorMessages.isEmpty) {
            controller.taskData();

            if (controller.taskId != null) {
              controller.editTask();
            } else {
              controller.createTask();
            }
            Navigator.pop(context, widget.taskController.classTask);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.taskController.clearTaskData();
    super.dispose();
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
          style: TextStyle(
            fontSize: AppTextSize.MEDIUM,
            color: Theme.of(context).colorScheme.inverseSurface,
            fontWeight: FontWeight.w300,
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
            activeColor: AppColors.GREEN,
            fillColor: AppColors.GREEN,
            inactiveColor: Theme.of(context).focusColor,
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
  final void Function(RecursiveDay day, bool selected) onSelectedDaysOfWeek;
  final Map<RecursiveDay, bool> selectedDays;

  const DaysOfWeekRow({
    super.key,
    required this.onSelectedDaysOfWeek,
    required this.selectedDays,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DaysOfWeekItem(
          dayOfWeek: t.sun,
          daySelected: (value) => onSelectedDaysOfWeek(RecursiveDay.SUN, value),
          selected: selectedDays[RecursiveDay.SUN] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: t.mon,
          daySelected: (value) => onSelectedDaysOfWeek(RecursiveDay.MON, value),
          selected: selectedDays[RecursiveDay.MON] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: t.tue,
          daySelected: (value) => onSelectedDaysOfWeek(RecursiveDay.TUE, value),
          selected: selectedDays[RecursiveDay.TUE] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: t.wed,
          daySelected: (value) => onSelectedDaysOfWeek(RecursiveDay.WED, value),
          selected: selectedDays[RecursiveDay.WED] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: t.thu,
          daySelected: (value) => onSelectedDaysOfWeek(RecursiveDay.THU, value),
          selected: selectedDays[RecursiveDay.THU] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: t.fri,
          daySelected: (value) => onSelectedDaysOfWeek(RecursiveDay.FRI, value),
          selected: selectedDays[RecursiveDay.FRI] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: t.sat,
          daySelected: (value) => onSelectedDaysOfWeek(RecursiveDay.SAT, value),
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
    return Flexible(
      child: FilterChip(
        shape: CircleBorder(
          side: BorderSide(
            color:
                selected ? AppColors.GREEN : Theme.of(context).highlightColor,
          ),
        ),
        labelPadding: const EdgeInsets.all(4.0),
        showCheckmark: false,
        color: selected
            ? WidgetStateProperty.all(AppColors.DARK)
            : WidgetStateProperty.all(Colors.transparent),
        label: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            dayOfWeek,
            style: TextStyle(
              color: selected
                  ? AppColors.GREEN
                  : Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
        selected: selected,
        onSelected: daySelected,
      ),
    );
  }
}
