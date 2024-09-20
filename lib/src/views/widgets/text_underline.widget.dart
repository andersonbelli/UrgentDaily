import 'package:flutter/material.dart';

import '../../helpers/constants/colors.constants.dart';

class TextUnderline extends StatelessWidget {
  const TextUnderline(this.text, {super.key, this.textSize = 18});

  final String text;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        height: 2,
        fontSize: textSize,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: const Offset(0, -10),
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ],
        color: Colors.transparent,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.GREEN,
        decorationThickness: 4,
        decorationStyle: TextDecorationStyle.wavy,
      ),
    );
  }
}
