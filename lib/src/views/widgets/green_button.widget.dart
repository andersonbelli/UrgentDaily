import 'package:flutter/material.dart';

import '../../helpers/constants/colors.constants.dart';
import '../../helpers/constants/padding.constants.dart';
import '../../helpers/constants/text_sizes.constants.dart';

class GreenButton extends StatelessWidget {
  const GreenButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isDisabled = false,
    this.width,
    this.margin,
  });

  final String text;
  final VoidCallback onTap;
  final bool isDisabled;
  final double? width;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.only(
            bottom: AppPadding.size16,
          ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.size16,
        vertical: AppPadding.size8,
      ),
      width: width ?? MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.GREEN,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.DARK),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppPadding.size8),
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
