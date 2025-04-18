import 'package:abelliz_essentials/constants/colors.constants.dart';
import 'package:abelliz_essentials/constants/padding.constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../routes.dart';
import '../../../controllers/auth/sign_in.controller.dart';
import '../../../helpers/di/di.dart';
import '../../../localization/localization.dart';
import '../../widgets/dashed_border.widget.dart';
import '../../widgets/message_dialog.widget.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    final isAnonymousUser = user == null || user!.isAnonymous;

    return SafeArea(
      child: Drawer(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  isAnonymousUser
                      ? MenuHeader.anonymous()
                      : MenuHeader(
                          userName: user!.displayName ?? t.noName,
                          email: user?.email,
                        ),
                  if (isAnonymousUser) ...[
                    ListTile(
                      leading: const Icon(
                        Icons.person_add_alt_1,
                        size: 30,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.GRAY,
                        size: 20,
                      ),
                      title: Text(t.signIn),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          Routes.singIn,
                        );
                      },
                    ),
                    const DashedDivider(),
                  ],
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      size: 30,
                    ),
                    title: Text(t.home),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.edit_document,
                      size: 30,
                    ),
                    title: const Text('Reports'),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            if (!isAnonymousUser)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    const DashedDivider(),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        size: 30,
                      ),
                      title: Text(t.logout),
                      onTap: () => showMessageDialog(
                        context,
                        title: t.okay,
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
              ),
          ],
        ),
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    super.key,
    required this.userName,
    required this.email,
  });

  final String? userName;
  final String? email;

  factory MenuHeader.anonymous() {
    return MenuHeader(
      userName: t.guestUser,
      email: t.loginToSaveYourTasks,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: AppColors.GREEN),
      accountName: Text(userName ?? t.noName),
      accountEmail: Text(email ?? ''),
      currentAccountPicture: const Padding(
        padding: EdgeInsets.only(bottom: AppPadding.kSize16),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person_outline, size: 40),
        ),
      ),
    );
  }
}
