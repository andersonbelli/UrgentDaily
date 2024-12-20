import 'package:flutter/material.dart';

import '../../controllers/base_controller.dart';
import 'default_appbar_child.widget.dart';
import 'loading.widget.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({
    super.key,
    required this.controller,
    required this.child,
    this.appBarText,
    this.customAppBar,
  }) : assert(
          (appBarText != null && customAppBar == null) ||
              (appBarText == null && customAppBar != null),
          'Either [appBarText] or [customAppBar] must be provided, but not both.',
        );

  final String? appBarText;
  final AppBar? customAppBar;
  final Widget child;
  final BaseController controller;

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
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Stack(
            children: [
              child,
              loadingWidget(controller.isLoading),
            ],
          );
        },
      ),
    );
  }
}
