import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../routes.dart';
import '../../../../controllers/auth/sign_in.controller.dart';
import '../../../../helpers/di/di.dart';
import '../../../../localization/localization.dart';
import '../../../widgets/dashed_border.widget.dart';
import '../../../widgets/message_dialog.widget.dart';
import 'menu_header.widget.dart';
import 'menu_item.widget.dart';

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
                    MenuItem(
                      icon: Icons.person_add_alt_1,
                      text: t.signIn,
                      showTrailingArrow: true,
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
                  MenuItem(
                    icon: Icons.home,
                    text: t.home,
                  ),
                  const MenuItem(
                    icon: Icons.edit_document,
                    text: 'Reports',
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
                    MenuItem(
                      icon: Icons.logout,
                      text: t.logout,
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
