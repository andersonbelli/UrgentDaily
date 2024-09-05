import 'package:flutter/material.dart';

import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../helpers/constants/colors.constants.dart';
import '../../helpers/constants/padding.constants.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.height = 0.5,
    this.padding = AppPadding.SMALL,
    this.dashLength = 10,
    this.borderWidth = 1,
    this.borderColor = AppColors.DARK_LIGHT,
  });

  final double height;
  final double padding;
  final double dashLength;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.SMALL,
      ),
      decoration:  BoxDecoration(
        border: DashedBorder.fromBorderSide(
          dashLength: dashLength,
          side: BorderSide(
            color: borderColor.withOpacity(0.3),
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}
