import 'package:flutter/material.dart';

import '../../controllers/home/home.controller.dart';
import '../../controllers/task/task.controller.dart';
import '../../helpers/config/di.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../calendar/calendar.view.dart';
import '../task/task.view.dart';
import 'widgets/create_new_task.widget.dart';
import 'widgets/no_tasks_yet.widget.dart';

class HomeView extends StatelessWidget {
  HomeView({
    super.key,
  });

  final HomeController homeController = getIt.get<HomeController>();
  final TaskController taskController = getIt.get<TaskController>();

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: homeController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () => Navigator.restorablePushNamed(
                context,
                CalendarView.routeName,
              ),
              child: Text(homeController.selectedDate.formatDate()),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: homeController.tasks.isEmpty
                        ? child!
                        : ListView.builder(
                            itemCount: homeController.tasks.length,
                            itemExtent: 120.0,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) {
                              final task = homeController.tasks[index];

                              return ListTile(
                                title: Text(
                                  task.title,
                                ),
                                subtitle: Text(
                                  '${task.title} - ${task.priority.name} - ${task.date?.formatDate()}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      taskController.editTaskData(
                                        task,
                                      );

                                      return FractionallySizedBox(
                                        heightFactor: 0.9,
                                        child: TaskView(),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  CreateNewTask(
                    taskController: taskController,
                  ),
                ],
              ),
              _loadingWidget,
            ],
          ),
        );
      },
      child: const NoTasksYet(),
    );
  }

  Widget get _loadingWidget => homeController.isLoading
      ? Container(
          color: AppColors.DARK.withOpacity(0.8),
          width: double.infinity,
          height: double.infinity,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.GREEN),
            ),
          ),
        )
      : const SizedBox.shrink();
}
