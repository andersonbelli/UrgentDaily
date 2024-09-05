import 'package:flutter/material.dart';

import '../../controllers/home/home.controller.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import 'widgets/create_new_task.widget.dart';
import 'widgets/home_calendar.widget.dart';
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
  @override
  void initState() {
    super.initState();
    widget.homeController.loadUserTasks();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.homeController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.homeController.selectedDate.formatDate()),
          ),
          body: Stack(
            children: [
              _loadingWidget,
              widget.homeController.tasks.isEmpty
                  ? child!
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.homeController.tasks.length,
                            itemExtent: 120.0,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  widget.homeController.tasks[index].title,
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => HomeCalendarWidget(
                                      selectedDate: widget
                                          .homeController.tasks[index].taskDate,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const CreateNewTask(),
                      ],
                    ),
            ],
          ),
        );
      },
      child: const NoTasksYet(),
    );
  }

  Widget get _loadingWidget => widget.homeController.isLoading
      ? const CircularProgressIndicator()
      : const SizedBox.shrink();
}
