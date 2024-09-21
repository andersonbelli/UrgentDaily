import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controllers/calendar/calendar.controller.dart';
import '../../controllers/home/home.controller.dart';
import '../../helpers/config/di.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../widgets/default_appbar_child.widget.dart';

class CalendarView extends StatelessWidget {
  CalendarView({super.key});

  final HomeController homeController = getIt.get<HomeController>();
  final CalendarController calendarController = getIt.get<CalendarController>();

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
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge(
          [
            calendarController,
            homeController,
          ],
        ),
        builder: (context, _) => TableCalendar(
          locale: AppLocalizations.of(context)!.localeName,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          currentDay: homeController.selectedDate,
          focusedDay: homeController.selectedDate,
          onDaySelected: (DateTime date, DateTime date1) {
            homeController.updateSelectedDate(date);
          },
          calendarFormat: CalendarFormat.twoWeeks,
          headerStyle: const HeaderStyle(formatButtonVisible: false),
          eventLoader: (DateTime date) {
            final events = [];

            for (final task in calendarController.twoWeeksTasks) {
              if (task.date.formatDate() == date.formatDate()) {
                events.addAll(task.tasks);
              }
            }

            return events;
          },
        ),
      ),
    );
  }
}
