import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/default_appbar_child.widget.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  static const routeName = '/calendar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarChild(
          Text(AppLocalizations.of(context)!.selectADay),
        ),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
      ),
    );
  }
}
