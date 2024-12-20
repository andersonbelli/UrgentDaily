import 'package:flutter/material.dart';

import '../../helpers/constants/colors.constants.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({
    super.key,
    required this.action,
  });

  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.close,
        color: Theme.of(context).colorScheme.inverseSurface,
        shadows: [
          BoxShadow(
            color: AppColors.DARK.withOpacity(0.3),
            blurRadius: 0.4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      onPressed: action ?? () => Navigator.pop(context),
    );
  }
}
