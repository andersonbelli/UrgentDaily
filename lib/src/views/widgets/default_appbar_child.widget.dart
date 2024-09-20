import 'package:flutter/material.dart';

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
        child,
        Divider(height: 4, color: Theme.of(context).highlightColor),
      ],
    );
  }
}
