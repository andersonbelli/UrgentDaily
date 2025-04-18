import 'package:abelliz_essentials/constants/colors.constants.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.showTrailingArrow = false,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool showTrailingArrow;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      trailing: showTrailingArrow
          ? const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.GRAY,
              size: 20,
            )
          : null,
      title: Text(text),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}
