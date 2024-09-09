import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/home/home.controller.dart';
import '../../controllers/task/task.controller.dart';
import '../../helpers/config/di.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/constants/padding.constants.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../../models/task.model.dart';
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
          floatingActionButton: FloatingActionButton(
            onPressed: () => CreateNewTask.showNewTaskModal(context),
            backgroundColor: AppColors.GREEN,
            tooltip: AppLocalizations.of(context)!.createNew,
            shape: CircleBorder(
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
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
                            TaskSection(
                              title: 'Urgent',
                              color: AppColors.PINK.withOpacity(0.5),
                              tasks: homeController.urgentTasks,
                            ),
                          );
                        }

                        if (homeController.importantTasks.isNotEmpty) {
                          listOfSections.add(
                            TaskSection(
                              title: 'Important',
                              color: AppColors.PURPLE.withOpacity(0.5),
                              tasks: homeController.importantTasks,
                            ),
                          );
                        }

                        if (homeController.importantNotUrgentTasks.isNotEmpty) {
                          listOfSections.add(
                            TaskSection(
                              title: 'Important, not urgent',
                              color: AppColors.BLUE_LIGHT.withOpacity(0.5),
                              tasks: homeController.importantNotUrgentTasks,
                            ),
                          );
                        }

                        if (homeController.notImportantTasks.isNotEmpty) {
                          listOfSections.add(
                            TaskSection(
                              title: 'Not important',
                              color: AppColors.GRAY.withOpacity(0.3),
                              tasks: homeController.notImportantTasks,
                            ),
                          );
                        }

                        listOfSections.add(CreateNewTask());

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

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.homeController,
    required this.taskController,
  });

  final Task task;
  final HomeController homeController;
  final TaskController taskController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      onTap: () => homeController.toggleCompletedTask(
        task,
        !task.isCompleted,
      ),
      leading: IconButton(
        onPressed: () {
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
        icon: const Icon(
          Icons.edit,
        ),
      ),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: (isTaskCompleted) => homeController.toggleCompletedTask(
          task,
          isTaskCompleted,
        ),
        checkColor: AppColors.DARK,
        activeColor: AppColors.GREEN,
      ),
    );
  }
}

class TaskSection extends StatelessWidget {
  const TaskSection({
    super.key,
    required this.title,
    required this.color,
    required this.tasks,
  });

  final String title;
  final Color color;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.MEDIUM,
        vertical: AppPadding.SMALL,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.MEDIUM),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: AppPadding.SMALL,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppPadding.SMALL,
              horizontal: AppPadding.LARGE,
            ),
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.DARK,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) => TaskItem(
              task: tasks[index],
              homeController: getIt<HomeController>(),
              taskController: getIt<TaskController>(),
            ),
          ),
        ],
      ),
    );
  }
}
