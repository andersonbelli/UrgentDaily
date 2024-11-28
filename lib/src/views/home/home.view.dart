import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/auth/sign_in.controller.dart';
import '../../controllers/calendar/calendar.controller.dart';
import '../../controllers/home/home.controller.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/di/di.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../../localization/localization.dart';
import '../auth/sign_in/sign_in.view.dart';
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
  final user = getIt<FirebaseAuth>().currentUser;

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
            tooltip: t.newTask,
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.GREEN),
                  accountName: user != null && !user!.isAnonymous
                      ? Text(user?.displayName ?? 'No Name')
                      : const Text('Guest User'),
                  accountEmail: user != null && !user!.isAnonymous
                      ? Text(user?.email ?? '')
                      : const Text('Anonymous Session'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: user != null && !user!.isAnonymous
                        ? const Icon(Icons.person, size: 40)
                        : const Icon(Icons.person_outline, size: 40),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () => Navigator.pop(context),
                ),
                if (user == null || user!.isAnonymous)
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Sign In'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInView(),
                        ),
                      );
                    },
                  ),
                if (user != null && !user!.isAnonymous)
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(t.logout),
                    onTap: () async {
                      await getIt<SignInController>().logout();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInView(),
                          ),
                        );
                      }
                    },
                  ),
              ],
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
                              title: t.urgent,
                              color: TaskPriority.URGENT.color.withOpacity(0.5),
                              tasks: homeController.urgentTasks,
                            ),
                          );
                        }

                        if (homeController.importantTasks.isNotEmpty) {
                          listOfSections.add(
                            HomeTaskSection(
                              title: t.important,
                              color:
                                  TaskPriority.IMPORTANT.color.withOpacity(0.5),
                              tasks: homeController.importantTasks,
                            ),
                          );
                        }

                        if (homeController.importantNotUrgentTasks.isNotEmpty) {
                          listOfSections.add(
                            HomeTaskSection(
                              title: t.importantNotUrgent,
                              color: TaskPriority.IMPORTANT_NOT_URGENT.color
                                  .withOpacity(0.5),
                              tasks: homeController.importantNotUrgentTasks,
                            ),
                          );
                        }

                        if (homeController.notImportantTasks.isNotEmpty) {
                          listOfSections.add(
                            HomeTaskSection(
                              title: t.notImportant,
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
