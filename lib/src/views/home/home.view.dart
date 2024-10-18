import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/calendar/calendar.controller.dart';
import '../../controllers/home/home.controller.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/di/di.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../calendar/calendar.view.dart';
import '../widgets/default_appbar_child.widget.dart';
import '../widgets/loading.widget.dart';
import '../widgets/show_task_modal.dart';
import '../widgets/text_underline.widget.dart';
import 'widgets/create_new_task.widget.dart';
import 'widgets/home_task_section.widget.dart';
import 'widgets/no_tasks_yet.widget.dart';

class HomeView extends StatelessWidget {
  HomeView({
    super.key,
  });

  final HomeController homeController = getIt.get<HomeController>();

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: homeController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                getIt.get<CalendarController>().updateTasksOfSelectedDay(
                      tasks: homeController.tasks,
                    );

                Navigator.restorablePushNamed(
                  context,
                  CalendarView.routeName,
                );
              },
              child: DefaultAppBarChild(
                TextUnderline(homeController.selectedDate.formatDate()),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async => await showTaskModal(
              context,
              onCompleteFunction: homeController.loadUserTasks,
            ),
            backgroundColor: AppColors.GREEN,
            tooltip: AppLocalizations.of(context)!.newTask,
            shape: const CircleBorder(
              side: BorderSide(
                color: AppColors.DARK,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.DARK,
            ),
          ),
          body: Stack(
            children: [
              homeController.tasks.isEmpty
                  ? child!
                  : Builder(
                      builder: (context) {
                        final List<Widget> listOfSections = [];

                        if (homeController.urgentTasks.isNotEmpty) {
                          listOfSections.add(
                            HomeTaskSection(
                              title: AppLocalizations.of(context)!.urgent,
                              color: TaskPriority.URGENT.color.withOpacity(0.5),
                              tasks: homeController.urgentTasks,
                            ),
                          );
                        }

                        if (homeController.importantTasks.isNotEmpty) {
                          listOfSections.add(
                            HomeTaskSection(
                              title: AppLocalizations.of(context)!.important,
                              color:
                                  TaskPriority.IMPORTANT.color.withOpacity(0.5),
                              tasks: homeController.importantTasks,
                            ),
                          );
                        }

                        if (homeController.importantNotUrgentTasks.isNotEmpty) {
                          listOfSections.add(
                            HomeTaskSection(
                              title: AppLocalizations.of(context)!
                                  .importantNotUrgent,
                              color: TaskPriority.IMPORTANT_NOT_URGENT.color
                                  .withOpacity(0.5),
                              tasks: homeController.importantNotUrgentTasks,
                            ),
                          );
                        }

                        if (homeController.notImportantTasks.isNotEmpty) {
                          listOfSections.add(
                            HomeTaskSection(
                              title: AppLocalizations.of(context)!.notImportant,
                              color: TaskPriority.NOT_IMPORTANT.color
                                  .withOpacity(0.3),
                              tasks: homeController.notImportantTasks,
                            ),
                          );
                        }

                        listOfSections.add(const CreateNewTask());

                        final outerListChildren = <SliverList>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => listOfSections[index],
                              childCount: listOfSections.length,
                            ),
                          ),
                        ];

                        return CustomScrollView(
                          slivers: outerListChildren,
                        );
                      },
                    ),
              loadingWidget(homeController.isLoading),
            ],
          ),
        );
      },
      child: const NoTasksYet(),
    );
  }
}
