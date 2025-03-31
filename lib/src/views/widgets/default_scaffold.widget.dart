import 'package:flutter/material.dart';

import 'default_appbar_child.widget.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({
    super.key,
    required this.child,
    this.appBarText,
    this.customAppBar,
  }) : assert(
          (appBarText != null && customAppBar == null) ||
              (appBarText == null && customAppBar != null),
          'Either [appBarText] or [customAppBar] must be provided.',
        );

  final String? appBarText;
  final AppBar? customAppBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarText != null
          ? AppBar(
              title: DefaultAppBarChild(
                Text(appBarText!),
              ),
            )
          : customAppBar,
      body: child,
    );
  }
}
