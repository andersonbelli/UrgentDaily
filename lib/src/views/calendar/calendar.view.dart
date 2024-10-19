import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controllers/calendar/calendar.controller.dart';
import '../../controllers/home/home.controller.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/di/di.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../widgets/default_appbar_child.widget.dart';
import '../widgets/loading.widget.dart';
import 'widgets/calendar_task_item.widget.dart';

class CalendarView extends StatelessWidget {
  CalendarView({super.key});

  final CalendarController calendarController = getIt.get<CalendarController>();
  final HomeController homeController = getIt.get<HomeController>();

  static const routeName = '/calendar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarChild(
          Text(
            AppLocalizations.of(context)!.selectADay,
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: calendarController.focusedDate,
            builder: (_, selectedDate, widget) {
              Widget action = widget!;

              if (homeController.selectedDate.formatDate() !=
                  selectedDate.formatDate()) {
                action = TextButton(
                  onPressed: () => homeController
                      .updateSelectedDate(selectedDate)
                      .then((_) => homeController.loadUserTasks())
                      .whenComplete(() {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }),
                  child: Text(
                    AppLocalizations.of(context)!.confirm,
                  ),
                );
              }

              return action;
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: calendarController,
        builder: (context, _) {
          return Stack(
            children: [
              Column(
                children: [
                  TableCalendar(
                    locale: AppLocalizations.of(context)!.localeName,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    currentDay: calendarController.getFocusedDate,
                    focusedDay: calendarController.getFocusedDate,
                    onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                      calendarController
                          .updateFocusedDate(selectedDay)
                          .whenComplete(
                            () => calendarController.updateTasksOfSelectedDay(),
                          );
                    },
                    calendarFormat: CalendarFormat.twoWeeks,
                    headerStyle: const HeaderStyle(formatButtonVisible: false),
                    onPageChanged: (_) =>
                        calendarController.tasksAlreadyLoaded = false,
                    calendarStyle: const CalendarStyle(
                      markerDecoration: BoxDecoration(
                        color: AppColors.GREEN,
                        shape: BoxShape.circle,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Theme.of(context).indicatorColor,
                      ),
                      weekendStyle: TextStyle(
                        color:
                            Theme.of(context).indicatorColor.withOpacity(0.8),
                      ),
                    ),
                    eventLoader: (DateTime date) {
                      calendarController.updateVisibleDates(date.formatDate());

                      final events = [];

                      for (final task in calendarController.twoWeeksTasks) {
                        if (task.date.formatDate() == date.formatDate()) {
                          events.addAll(task.tasks);
                        }
                      }

                      return events;
                    },
                  ),
                  DefaultAppBarChild(
                    Text(
                      calendarController.getFocusedDate.formatDate(),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: calendarController.tasksOfSelectedDay.length,
                      itemBuilder: (context, index) {
                        final task =
                            calendarController.tasksOfSelectedDay[index];

                        return CalendarTaskItem(
                          task: task,
                          title: task.title,
                          priority: task.priority,
                          isCompleted: task.isCompleted,
                        );
                      },
                    ),
                  ),
                ],
              ),
              loadingWidget(calendarController.isLoading),
            ],
          );
        },
      ),
    );
  }
}
