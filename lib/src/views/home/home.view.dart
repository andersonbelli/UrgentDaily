import 'package:flutter/material.dart';

import '../../controllers/home/home.controller.dart';
import '../../controllers/task/task.controller.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../calendar/calendar.view.dart';
import '../task/task.view.dart';
import 'widgets/create_new_task.widget.dart';
import 'widgets/no_tasks_yet.widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  static const routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TaskController taskController; // TODO: Dependency Injection (DI) here.

  @override
  void initState() {
    super.initState();
    taskController = TaskController(widget.homeController);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.homeController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () => Navigator.restorablePushNamed(
                context,
                CalendarView.routeName,
              ),
              child: Text(widget.homeController.selectedDate.formatDate()),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: widget.homeController.tasks.isEmpty
                        ? child!
                        : ListView.builder(
                            itemCount: widget.homeController.tasks.length,
                            itemExtent: 120.0,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) {
                              final task = widget.homeController.tasks[index];

                              return ListTile(
                                title: Text(
                                  task.title,
                                ),
                                subtitle: Text(
                                  '${task.id} - ${task.priority.name} - ${task.date?.formatDate()}',
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
                                        child: TaskView(
                                          taskController: taskController,
                                        ),
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

  Widget get _loadingWidget => widget.homeController.isLoading
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
