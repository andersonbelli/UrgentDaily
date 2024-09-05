import 'package:flutter/material.dart';

import '../../helpers/constants/colors.constants.dart';
import '../../helpers/constants/text_sizes.constants.dart';

class GreenButton extends StatelessWidget {
  const GreenButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.GREEN,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.DARK),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.DARK,
              fontWeight: FontWeight.bold,
              fontSize: AppTextSize.MEDIUM,
            ),
          ),
        ),
      ),
    );
  }
}
