import 'package:flutter/material.dart';

import '../../widgets/dashed_border.widget.dart';
import '../../widgets/green_button.widget.dart';

class CreateNewTask extends StatelessWidget {
  const CreateNewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashedDivider(),
        GreenButton(
          text: 'CREATE NEW',
          onTap: () => print(''),
        ),
      ],
    );
  }
}