import 'package:flutter/material.dart';

import '../task/task.view.dart';

showTaskModal(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: TaskView(),
      ),
    );
