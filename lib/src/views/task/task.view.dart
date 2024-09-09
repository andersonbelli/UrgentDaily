import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/task/task.controller.dart';
import '../../helpers/config/di.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/constants/padding.constants.dart';
import '../../helpers/constants/text_sizes.constants.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/enums/recursive_days.enum.dart';
import '../widgets/dashed_border.widget.dart';
import '../widgets/green_button.widget.dart';
import 'widgets/calendar_picker.widget.dart';

class TaskView extends StatefulWidget {
  TaskView({
    super.key,
  });

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
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            controller.taskId == null
                                ? AppLocalizations.of(context)!.newTask
                                : controller.originalTitle,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: AppTextSize.LARGE,
                              color: AppColors.GREEN,
                            ),
                          ),
                        ),
                      ),
                      TaskFieldWithTitle(
                        title: AppLocalizations.of(context)!.title,
                        child: TextField(
                          cursorColor: Theme.of(context).colorScheme.outline,
                          cursorErrorColor:
                              Theme.of(context).colorScheme.outline,
                          maxLength: 120,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: AppLocalizations.of(context)!
                                .whatAreYouPlanning,
                            hintStyle: const TextStyle(
                              color: AppColors.GRAY,
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: controller.validationErrorMessages
                                        .containsKey(ErrorFieldsEnum.TITLE)
                                    ? Theme.of(context).colorScheme.error
                                    : AppColors.DARK_LIGHT.withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                            focusedErrorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.GRAY),
                            ),
                            errorText: controller.validationErrorMessages
                                    .containsKey(ErrorFieldsEnum.TITLE)
                                ? controller.validationErrorMessages[
                                    ErrorFieldsEnum.TITLE]
                                : '',
                          ),
                          controller: controller.title,
                          onChanged: (value) {
                            controller.title.clearComposing();
                            if (value.trim().isNotEmpty &&
                                controller.validationErrorMessages
                                    .containsKey(ErrorFieldsEnum.TITLE)) {
                              controller
                                  .removeValidationError(ErrorFieldsEnum.TITLE);
                            } else {
                              controller.validateFields(context);
                            }
                          },
                        ),
                      ),
                      TaskFieldWithTitle(
                        title: AppLocalizations.of(context)!.date,
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
                            onChanged: (value) {
                              controller.toggleRecursive(recursive: value);
                            },
                            checkColor: AppColors.DARK,
                            activeColor: AppColors.GREEN,
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.toggleRecursive();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.recursiveTask,
                              style: const TextStyle(
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
                            AppLocalizations.of(context)!.priority,
                            style: const TextStyle(
                              fontSize: AppTextSize.MEDIUM,
                              color: AppColors.GRAY,
                              fontWeight: FontWeight.w100,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          RadioPriority(
                            title: AppLocalizations.of(context)!
                                .urgent
                                .toLowerCase(),
                            groupPriority: controller.taskPriority,
                            priority: TaskPriority.URGENT,
                            selectedPriority: controller.selectTaskPriority,
                          ),
                          RadioPriority(
                            title: AppLocalizations.of(context)!
                                .important
                                .toLowerCase(),
                            groupPriority: controller.taskPriority,
                            priority: TaskPriority.IMPORTANT,
                            selectedPriority: controller.selectTaskPriority,
                          ),
                          RadioPriority(
                            title: AppLocalizations.of(context)!
                                .importantNotUrgent
                                .toLowerCase(),
                            groupPriority: controller.taskPriority,
                            priority: TaskPriority.IMPORTANT_NOT_URGENT,
                            selectedPriority: controller.selectTaskPriority,
                          ),
                          RadioPriority(
                            title: AppLocalizations.of(context)!
                                .notImportant
                                .toLowerCase(),
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
            Visibility(
              visible: controller.validationErrorMessages.isNotEmpty,
              child: Flexible(
                child: Container(
                  padding: const EdgeInsets.all(AppPadding.MEDIUM),
                  color: Theme.of(context).focusColor,
                  child: ListView.builder(
                    itemCount: controller.validationErrorMessages.length,
                    clipBehavior: Clip.antiAlias,
                    itemBuilder: (context, index) {
                      return Text(
                        '* ${controller.validationErrorMessages.values.elementAt(index)}',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                      );
                    },
                  ),
                ),
              ),
            ),
            child!,
          ],
        );
      },
      child: GreenButton(
        text: widget.taskController.taskId == null
            ? AppLocalizations.of(context)!.createTask
            : AppLocalizations.of(context)!.editTask,
        isDisabled: controller.validationErrorMessages.isNotEmpty,
        onTap: () {
          widget.taskController.validateFields(context);

          if (widget.taskController.validationErrorMessages.isEmpty) {
            widget.taskController.taskAction();
            Navigator.pop(context);
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DaysOfWeekItem(
          dayOfWeek: AppLocalizations.of(context)!.sun,
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.SUN, value);
          },
          selected: selectedDays[RecursiveDay.SUN] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: AppLocalizations.of(context)!.mon,
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.MON, value);
          },
          selected: selectedDays[RecursiveDay.MON] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: AppLocalizations.of(context)!.tue,
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.TUE, value);
          },
          selected: selectedDays[RecursiveDay.TUE] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: AppLocalizations.of(context)!.wed,
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.WED, value);
          },
          selected: selectedDays[RecursiveDay.WED] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: AppLocalizations.of(context)!.thu,
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.THU, value);
          },
          selected: selectedDays[RecursiveDay.THU] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: AppLocalizations.of(context)!.fri,
          daySelected: (value) {
            onSelectedDaysOfWeek(RecursiveDay.FRI, value);
          },
          selected: selectedDays[RecursiveDay.FRI] == true,
        ),
        DaysOfWeekItem(
          dayOfWeek: AppLocalizations.of(context)!.sat,
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
    return Flexible(
      child: FilterChip(
        shape: CircleBorder(
          side: BorderSide(
            color:
                selected ? AppColors.GREEN : Theme.of(context).highlightColor,
          ),
        ),
        labelPadding: const EdgeInsets.all(8.0),
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
