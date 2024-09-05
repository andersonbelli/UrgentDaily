import 'package:flutter/material.dart';

class NoTasksYet extends StatelessWidget {
  const NoTasksYet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Placeholder(
          color: Colors.red,
        ),
        Text(
          'no tasks yet :(',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
