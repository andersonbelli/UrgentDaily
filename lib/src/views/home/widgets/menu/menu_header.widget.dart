import 'package:abelliz_essentials/constants/colors.constants.dart';
import 'package:abelliz_essentials/constants/padding.constants.dart';
import 'package:flutter/material.dart';

import '../../../../localization/localization.dart';

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
