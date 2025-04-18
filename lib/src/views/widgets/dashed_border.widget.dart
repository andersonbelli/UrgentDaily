import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../helpers/constants/colors.constants.dart';
import '../../helpers/constants/padding.constants.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.height = 0.5,
    this.padding = AppPadding.size8,
    this.dashLength = 10,
    this.borderWidth = 1,
    this.borderColor = AppColors.DARK_LIGHT,
    this.child = const SizedBox.shrink(),
  });

  final double height;
  final double padding;
  final double dashLength;
  final Color borderColor;
  final double borderWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: child == const SizedBox.shrink() ? height : null,
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.size8,
      ),
      decoration: BoxDecoration(
        border: DashedBorder.fromBorderSide(
          dashLength: dashLength,
          side: BorderSide(
            color: borderColor.withValues(alpha: 0.3),
            width: borderWidth,
          ),
        ),
      ),
      child: child,
    );
  }
}
