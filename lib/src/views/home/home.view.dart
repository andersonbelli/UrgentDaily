import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../routes.dart';
import '../../controllers/auth/sign_in.controller.dart';
import '../../controllers/home/home.controller.dart';
import '../../helpers/constants/colors.constants.dart';
import '../../helpers/di/di.dart';
import '../../helpers/enums/priority.enum.dart';
import '../../helpers/extensions/datetime_formatter.dart';
import '../../localization/localization.dart';
import '../calendar/calendar.view.dart';
import '../widgets/base_controller_ui.widget.dart';
import '../widgets/default_appbar_child.widget.dart';
import '../widgets/loading.widget.dart';
import '../widgets/message_dialog.widget.dart';
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

  static const String routeName = Routes.home;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: homeController.loadUserTasks(),
      builder: (context, _) {
        baseControllerUI(context, homeController);

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
                  child: DefaultAppBarChild(
                    TextUnderline(homeController.selectedDate.formatDate()),
                  ),
                ),
                actions: homeController.tasks.isEmpty
                    ? []
                    : [
                        homeController.isEditMode
                            ? TextButton(
                                onPressed: () => homeController.toggleEditMode(),
                                child: Text(
                                  t.done,
                                  style: const TextStyle(color: AppColors.BLUE),
                                ),
                              )
                            : IconButton(
                                onPressed: () => homeController.toggleEditMode(),
                                icon: const Icon(Icons.edit),
                              ),
                      ],
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
              drawer: MenuDrawer(user: user),
              body: Stack(
                children: [
                  homeController.tasks.isEmpty
                      ? homeController.isLoading
                          ? const SizedBox.shrink()
                          : NoTasksYet(homeController)
                      : Builder(
                          builder: (context) {
                            final List<Widget> listOfSections = [];

                            if (homeController.urgentTasks.isNotEmpty) {
                              listOfSections.add(
                                HomeTaskSection(
                                  title: t.urgent,
                                  color: TaskPriority.URGENT.color.withValues(alpha: 0.5),
                                  tasks: homeController.urgentTasks,
                                ),
                              );
                            }

                            if (homeController.importantTasks.isNotEmpty) {
                              listOfSections.add(
                                HomeTaskSection(
                                  title: t.important,
                                  color: TaskPriority.IMPORTANT.color.withValues(alpha: 0.5),
                                  tasks: homeController.importantTasks,
                                ),
                              );
                            }

                            if (homeController.importantNotUrgentTasks.isNotEmpty) {
                              listOfSections.add(
                                HomeTaskSection(
                                  title: t.importantNotUrgent,
                                  color: TaskPriority.IMPORTANT_NOT_URGENT.color.withValues(alpha: 0.5),
                                  tasks: homeController.importantNotUrgentTasks,
                                ),
                              );
                            }

                            if (homeController.notPriorityTasks.isNotEmpty) {
                              listOfSections.add(
                                HomeTaskSection(
                                  title: t.notPriority,
                                  color: TaskPriority.NOT_PRIORITY.color.withValues(alpha: 0.3),
                                  tasks: homeController.notPriorityTasks,
                                ),
                              );
                            }

                            listOfSections.add(
                              const CreateNewTask(),
                            );

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
          // child: baseControllerUI(context, homeController),
        );
      },
    );
  }
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.GREEN),
            accountName: user != null && !user!.isAnonymous ? Text(user?.displayName ?? t.noName) : Text(t.guestUser),
            accountEmail: user != null && !user!.isAnonymous ? Text(user?.email ?? '') : Text(t.loginToSaveYourTasks),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: user != null && !user!.isAnonymous
                  ? const Icon(Icons.person, size: 40)
                  : const Icon(Icons.person_outline, size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(t.home),
            onTap: () => Navigator.pop(context),
          ),
          if (user == null || user!.isAnonymous)
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(t.signIn),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  Routes.singIn,
                );
              },
            ),
          if (user != null && !user!.isAnonymous)
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(t.logout),
              onTap: () => showMessageDialog(
                context,
                t.confirmLogout,
                buttonText: t.confirm,
                buttonAction: () async {
                  await getIt<SignInController>().logout();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                showCancelButton: true,
              ),
            ),
        ],
      ),
    );
  }
}
