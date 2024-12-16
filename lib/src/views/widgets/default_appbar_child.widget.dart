import 'package:flutter/material.dart';

import '../../helpers/constants/padding.constants.dart';

class DefaultAppBarChild extends StatelessWidget {
  const DefaultAppBarChild(
    this.child, {
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppPadding.size8),
          child: child,
        ),
        Divider(height: 4, color: Theme.of(context).highlightColor),
      ],
    );
  }
}
